#!/bin/bash
set -e

echo "=== Metagenomics Codespace Setup ==="

# Determine workspace location
# In Codespaces: /workspaces/codespace-metagenomics-analysis
# Fallback for local testing
if [ -d "/workspaces/codespace-metagenomics-analysis" ]; then
    REPO_ROOT="/workspaces/codespace-metagenomics-analysis"
else
    REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fi

WORKSPACE="${REPO_ROOT}/dc_workshop"

echo "Repository: ${REPO_ROOT}"
echo "Workspace: ${WORKSPACE}"
echo ""

# Create workspace directory structure IN THE REPO
echo "Creating workspace directories..."
mkdir -p ${WORKSPACE}/data/{untrimmed_fastq,trimmed_fastq}
mkdir -p ${WORKSPACE}/results/{fastqc_untrimmed_reads,fastqc_trimmed_reads,assembly_JC1A}
mkdir -p ${WORKSPACE}/{taxonomy,mags,docs}

# Create symlinks from rstudio home for convenience
# This allows lessons to use ~/dc_workshop paths AND see lesson files
if [ ! -L "/home/rstudio/dc_workshop" ]; then
    ln -sf ${WORKSPACE} /home/rstudio/dc_workshop
    echo "✅ Created symlink: ~/dc_workshop -> ${WORKSPACE}"
fi

# Symlink lessons directory for easy access in RStudio
if [ ! -L "/home/rstudio/lessons" ]; then
    ln -sf ${REPO_ROOT}/lessons /home/rstudio/lessons
    echo "✅ Created symlink: ~/lessons -> ${REPO_ROOT}/lessons"
fi

# Symlink figures directory (referenced in lessons)
if [ ! -L "/home/rstudio/fig" ]; then
    ln -sf ${REPO_ROOT}/fig /home/rstudio/fig
    echo "✅ Created symlink: ~/fig -> ${REPO_ROOT}/fig"
fi

# Set RStudio to open the project by default
# This gives users access to all repo files in RStudio Files pane
mkdir -p /home/rstudio/.rstudio/projects_settings
cat > /home/rstudio/.rstudio/projects_settings/last-project-path << EOF
${REPO_ROOT}/metagenomics-workshop.Rproj
EOF

# Auto-open welcome file on first launch
mkdir -p /home/rstudio/.rstudio/sessions/active
cat > /home/rstudio/.rstudio/sessions/active/session-persistent-state << EOF
{
    "working-dir" : "${REPO_ROOT}",
    "console-history" : [],
    "docs" : [
        {
            "path" : "${REPO_ROOT}/WELCOME.md",
            "type" : "markdown"
        }
    ]
}
EOF

chown -R rstudio:rstudio /home/rstudio/.rstudio 2>/dev/null || true

# Download Trimmomatic adapters
echo "Downloading Trimmomatic adapters..."
cd ${WORKSPACE}/data/untrimmed_fastq
if [ ! -f "TruSeq3-PE.fa" ]; then
    wget -q -O TruSeq3-PE.fa \
        https://raw.githubusercontent.com/timflutre/trimmomatic/master/adapters/TruSeq3-PE-2.fa \
        && echo "✅ Downloaded TruSeq3-PE.fa" \
        || echo "⚠️  Could not download adapters"
fi

# Create data download helper script
cat > ${WORKSPACE}/data/download_data.sh << 'DOWNLOAD_SCRIPT'
#!/bin/bash
# Data Download Helper for Metagenomics Workshop
#
# TODO: Update with actual Zenodo link when available

echo "================================================"
echo " Metagenomics Workshop - Data Download Helper"
echo "================================================"
echo ""
echo "Options for obtaining sample data:"
echo ""
echo "1. ZENODO (Recommended - Pre-packaged data)"
echo "   Update this script with Zenodo URL"
echo "   Example: wget https://zenodo.org/record/XXXXX/files/dataset.tar.gz"
echo ""
echo "2. SRA (Requires sra-toolkit)"
echo "   fastq-dump --split-files --gzip ERS1949784  # JC1A"
echo "   mv ERS1949784_1.fastq.gz JC1A_R1.fastq.gz"
echo "   mv ERS1949784_2.fastq.gz JC1A_R2.fastq.gz"
echo ""
echo "3. Pre-computed Results (For testing)"
echo "   Check results/precomputed/ if available"
echo ""
echo "For GitHub Codespaces free tier:"
echo "  ✅ Use JC1A sample (48MB, ~1hr assembly)"
echo "  ⚠️  Avoid JP4D sample (800MB, 4-6hr assembly, 16GB RAM)"
echo ""
DOWNLOAD_SCRIPT

chmod +x ${WORKSPACE}/data/download_data.sh

# Install conda environment (if not baked into image)
echo "Setting up conda environment..."
conda init bash
source ~/.bashrc || true

if conda env list | grep -q "^metagenomics "; then
    echo "✅ Conda environment 'metagenomics' already exists"
else
    echo "Creating conda environment (~10 minutes)..."
    conda create -n metagenomics -y -c bioconda -c conda-forge \
        python=3.9 \
        fastqc=0.12.1 \
        trimmomatic=0.39 \
        spades=3.15.5 \
        bowtie2=2.5.1 \
        kraken2=2.1.3 \
        maxbin2=2.2.7 \
        checkm-genome=1.2.2 \
        kraken-biom=1.2.0 \
        screen
    echo "✅ Conda environment created"
fi

# Auto-activate in bashrc
if [ -f "/home/rstudio/.bashrc" ] && ! grep -q "conda activate metagenomics" /home/rstudio/.bashrc; then
    echo "" >> /home/rstudio/.bashrc
    echo "# Auto-activate metagenomics environment" >> /home/rstudio/.bashrc
    echo "conda activate metagenomics 2>/dev/null || true" >> /home/rstudio/.bashrc
fi

# Create workspace README
cat > ${WORKSPACE}/README.md << 'WORKSPACE_README'
# Metagenomics Workshop Workspace

## Quick Start

### 1. Download Data
```bash
cd ~/dc_workshop/data
./download_data.sh
```

### 2. RStudio
Open http://localhost:8787
- Working directory: `~/dc_workshop/`
- Lessons: `/workspaces/codespace-metagenomics-analysis/lessons/`

### 3. Terminal Commands
```bash
cd ~/dc_workshop/data/untrimmed_fastq
fastqc *.fastq.gz
```

## Directory Structure
```
~/dc_workshop/
├── data/untrimmed_fastq/    ← Put raw FASTQ files here
├── data/trimmed_fastq/       ← Trimmed outputs go here
├── results/                  ← Analysis outputs
├── taxonomy/                 ← Kraken2/kraken-biom outputs
└── mags/                     ← Binning outputs
```

## File Paths in Lessons

Lessons reference paths like:
- `~/dc_workshop/data/...` - Works! (symlink to repo)
- `setwd("~/dc_workshop/taxonomy/")` - Works in RStudio!

Both point to: `/workspaces/codespace-metagenomics-analysis/dc_workshop/`
WORKSPACE_README

# Stop RStudio Server by default (save resources)
echo "Stopping RStudio Server (start on-demand to save CPU)..."
sudo rstudio-server stop 2>/dev/null || true

echo ""
echo "=== Setup Complete! ==="
echo ""
echo "📁 Workspace: ~/dc_workshop/ (symlink)"
echo "   Real path: ${WORKSPACE}"
echo ""
echo "🧬 Next steps:"
echo "   1. Download data: cd ~/dc_workshop/data && ./download_data.sh"
echo "   2. Follow lessons 1-6 (command-line tools)"
echo "   3. When ready for R (lessons 7-9): ./start-rstudio.sh"
echo ""
echo "✅ R packages: phyloseq, ggplot2, vegan (pre-installed)"
echo "✅ Conda tools: fastqc, trimmomatic, spades, kraken2 (ready)"
echo ""
echo "💡 RStudio Server is STOPPED to save CPU resources."
echo "   Start when needed: ./start-rstudio.sh"
echo "   Stop when done: ./stop-rstudio.sh"
echo ""
