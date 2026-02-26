#!/bin/bash
set -e

echo "=== Metagenomics Codespace Quick Setup ==="
echo "R packages already installed in image!"
echo ""

# Initialize conda
echo "Initializing conda..."
conda init bash
source ~/.bashrc || true

# Create conda environment (bioinformatics tools only)
echo "Creating conda environment with bioinformatics tools..."
echo "(this takes ~10 minutes, much faster than before)"
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

echo "Conda environment created!"

# Create workspace directories
echo "Creating workspace directories..."
mkdir -p ~/dc_workshop/data/{untrimmed_fastq,trimmed_fastq}
mkdir -p ~/dc_workshop/results/{fastqc_untrimmed_reads,fastqc_trimmed_reads,assembly_JC1A}
mkdir -p ~/dc_workshop/{taxonomy,mags,docs}

# Download Trimmomatic adapters
cd ~/dc_workshop/data/untrimmed_fastq
wget -q -O TruSeq3-PE.fa \
    https://raw.githubusercontent.com/timflutre/trimmomatic/master/adapters/TruSeq3-PE-2.fa \
    || echo "Note: Could not download adapters"

# Create data download placeholder
cat > download_data.sh << 'EOF'
#!/bin/bash
# Download data from NCBI SRA or your preferred source
echo "Data download script. Modify to download actual data."
echo "For free tier, use JC1A sample only (48MB compressed)"
EOF
chmod +x download_data.sh

# Auto-activate conda environment
if ! grep -q "conda activate metagenomics" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# Auto-activate metagenomics environment" >> ~/.bashrc
    echo "conda activate metagenomics" >> ~/.bashrc
fi

# Create README
cat > ~/README.md << 'EOF'
# Metagenomics Analysis Codespace

## Quick Start

### Access RStudio Server
Open: http://localhost:8787
- Username: rstudio
- Password: metagenomics

### Using the Environment
- **Command-line tools**: `conda activate metagenomics` (auto-activated in new terminals)
- **R analysis**: Use RStudio Console directly (packages pre-installed)

### R Packages Included
All packages are pre-installed in the image:
- phyloseq, ggplot2, vegan, patchwork, RColorBrewer
- All Bioconductor dependencies

Test with: `library(phyloseq)`

## Workspace Structure
```
~/dc_workshop/
├── data/
│   ├── untrimmed_fastq/
│   └── trimmed_fastq/
├── results/
├── taxonomy/
├── mags/
└── docs/
```

## Software Installed
- **FastQC, Trimmomatic, MetaSPAdes, Kraken2, MaxBin2, CheckM**
- **R 4.3 + RStudio Server + phyloseq ecosystem**
EOF

echo ""
echo "=== Setup Complete! ==="
echo ""
echo "✅ R packages: Pre-installed in image (phyloseq, ggplot2, etc.)"
echo "✅ Conda tools: Installed (~10 min vs. ~25 min before)"
echo "✅ Workspace: Ready at ~/dc_workshop"
echo ""
echo "🎉 Open RStudio at http://localhost:8787"
echo ""
