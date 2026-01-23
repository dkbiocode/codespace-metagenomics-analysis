#!/bin/bash
set -e

echo "=== Setting up Metagenomics Analysis Environment ==="

# Install system dependencies for bioinformatics tools AND R packages (requires root)
echo "Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    wget \
    curl \
    gzip \
    bzip2 \
    unzip \
    git \
    screen \
    less \
    nano \
    default-jre \
    perl \
    python3-pip \
    build-essential \
    libz-dev \
    libbz2-dev \
    liblzma-dev \
    libncurses5-dev \
    libglpk40 \
    libglpk-dev \
    libhdf5-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libgmp-dev

# Clean up to save space
sudo apt-get clean
sudo rm -rf /var/lib/apt/lists/*


# Install R packages for metagenomics analysis (using system R, not conda R)
echo "Installing R packages for phyloseq analysis..."
echo "(using pre-compiled binaries for fast installation)"


# Install remaining R packages using Posit Package Manager (P3M) binaries
echo "Installing additional R packages from P3M..."
sudo R -e "options(repos = c(CRAN = 'https://p3m.dev/cran/__linux__/jammy/latest')); \
    install.packages(c('digest', 'jsonlite', 'plyr', 'Rcpp', 'iterators', 'foreach', 'bitops', 'RCurl', 'ggplot2', 'RColorBrewer', 'patchwork', 'vegan', 'stringr', 'crayon','lattice'))"


# Install pre-built binaries for packages with heavy compilation (HDF5, igraph, phyloseq)
echo "Installing pre-built R package binaries..."
for tgz in /workspaces/codespace-metagenomics-analysis/binaries/*.tar.gz;
do
  sudo R CMD INSTALL $tgz
done

R -e "library(phyloseq);"
echo "R package installation complete!"


# Install conda environment with bioinformatics tools only (NOT R packages)
# R packages are installed separately using system R to avoid conda/RStudio conflicts
echo "Initializing conda for bash..."
conda init bash
source ~/.bashrc || true

# Create metagenomics conda environment with bioinformatics tools only
echo "Creating metagenomics conda environment with bioinformatics tools..."
echo "(this may take 10-15 minutes)..."
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

echo "Conda environment created successfully!"
echo "Verifying installations..."
conda run -n metagenomics python --version


# Create workspace directory structure
echo "Creating workspace directories..."
mkdir -p ~/dc_workshop/data/{untrimmed_fastq,trimmed_fastq}
mkdir -p ~/dc_workshop/results/{fastqc_untrimmed_reads,fastqc_trimmed_reads,assembly_JC1A}
mkdir -p ~/dc_workshop/{taxonomy,mags,docs}

# Download a small test dataset (JC1A only - 48MB total compressed)
echo "Setting up data directory..."
cd ~/dc_workshop/data/untrimmed_fastq

# Note: These would need to be the actual SRA accessions or hosted URLs
# For now, create placeholder script
cat > download_data.sh << 'EOF'
#!/bin/bash
# Download data from NCBI SRA or your preferred source
# Example using SRA toolkit (if installed):
# fastq-dump --split-files --gzip ERS1949784  # JC1A
# fastq-dump --split-files --gzip ERS1949771  # JP41

echo "Data download script created. Run this to download actual data."
echo "For free tier usage, we recommend using only JC1A sample (48MB compressed)"
EOF

chmod +x download_data.sh

# Download Trimmomatic adapters
echo "Downloading Trimmomatic adapters..."
wget -q -O TruSeq3-PE.fa \
    https://raw.githubusercontent.com/timflutre/trimmomatic/master/adapters/TruSeq3-PE-2.fa \
    || echo "Note: Could not download adapters, will need to provide manually"

# Create README for users
cat > ~/README.md << 'EOF'
# Metagenomics Analysis Codespace

## Getting Started

### 1. Access RStudio Server
Open your browser to: http://localhost:8787
- Username: rstudio
- Password: metagenomics

### 2. Using the environment
- **For command-line tools** (FastQC, Trimmomatic, MetaSPAdes, etc.):
  - In RStudio Terminal tab or VS Code terminal:
  ```bash
  conda activate metagenomics
  ```
- **For R analysis** (phyloseq, ggplot2, etc.):
  - Use RStudio Console directly (R packages are already available)
  - No conda activation needed for R work

### 3. Download sample data
```bash
cd ~/dc_workshop/data/untrimmed_fastq
./download_data.sh
```

## Free Tier Optimization Tips

This Codespace is configured for GitHub Free tier (2-core, 8GB RAM, 32GB storage):

- **Use JC1A sample** for learning (24MB each, fast assembly)
- **Skip or use pre-computed results** for resource-intensive steps:
  - MetaSPAdes assembly on JP4D (use JC1A instead)
  - Kraken2 taxonomic assignment (pre-computed results provided)
  - CheckM quality assessment (pre-computed results provided)

- **Time limits**: Free tier = 60 hours/month
  - Lessons 1-3: ~2 hours
  - Lesson 4 (Assembly): ~1 hour (JC1A) vs 4-6 hours (JP4D)
  - Lessons 5-6: ~1 hour (with pre-computed Kraken)
  - Lessons 7-9: ~2 hours (R analysis)
  - **Total: ~6-8 hours for full course**

## Workspace Structure

```
~/dc_workshop/
├── data/
│   ├── untrimmed_fastq/    # Raw FASTQ files
│   └── trimmed_fastq/      # Trimmed FASTQ files
├── results/
│   ├── fastqc_untrimmed_reads/
│   ├── fastqc_trimmed_reads/
│   └── assembly_JC1A/
├── taxonomy/               # Kraken2 outputs
├── mags/                   # MaxBin outputs
└── docs/                   # Generated reports
```

## Software Installed

**Command-line tools (conda environment):**
- **Quality Control**: FastQC 0.12.1
- **Trimming**: Trimmomatic 0.39
- **Assembly**: MetaSPAdes 3.15.5
- **Binning**: MaxBin2 2.2.7, CheckM 1.2.2
- **Taxonomy**: Kraken2 2.1.3, Krona 2.8.1, kraken-biom 1.2.0

**R environment (system R with RStudio Server):**
- **R 4.3** with RStudio Server
- **phyloseq** - Metagenome analysis framework
- **ggplot2** - Data visualization
- **RColorBrewer** - Color palettes
- **patchwork** - Multi-panel plots
- **vegan** - Diversity analysis

## Lessons

Navigate to `lessons/` directory to find all lesson materials.

## Troubleshooting

### RStudio won't connect
- Check that port 8787 is forwarded
- Try accessing via the Ports tab in VS Code

### Conda environment not found
```bash
conda init bash
source ~/.bashrc
conda activate metagenomics
```

### Out of storage space
```bash
# Clean conda cache
conda clean --all -y

# Remove unnecessary files
rm -rf ~/dc_workshop/results/assembly_JC1A/K*/
```

### Assembly taking too long
- Use `screen` to run in background
- Or use pre-computed assembly results provided in `results/precomputed/`
EOF

# Add conda initialization to .bashrc if not already there
if ! grep -q "conda activate metagenomics" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# Auto-activate metagenomics environment" >> ~/.bashrc
    echo "conda activate metagenomics" >> ~/.bashrc
fi

echo ""
echo "=== Setup Complete! ==="
echo ""
echo "🎉 Your Metagenomics Analysis environment is ready!"
echo ""
echo "Next steps:"
echo "1. Open RStudio Server at http://localhost:8787"
echo "2. Username: rstudio | Password: metagenomics"
echo "3. Check ~/README.md for detailed instructions"
echo ""
echo "💡 Free tier tip: Use JC1A sample for faster learning!"
echo ""
