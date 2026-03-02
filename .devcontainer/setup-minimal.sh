#!/bin/bash
set -e

echo "=== Metagenomics Codespace Minimal Setup (Free Tier Optimized) ==="
echo ""

# Install micromamba (lightweight conda alternative - saves ~2GB)
echo "Installing micromamba..."
cd /tmp
curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba
sudo mv bin/micromamba /usr/local/bin/
rm -rf bin

# Initialize micromamba
micromamba shell init -s bash -p ~/micromamba
source ~/.bashrc || true

# Create minimal conda environment
# REMOVED heavy tools: checkm-genome (~2GB), maxbin2 (~1GB), kraken2 (~500MB), bowtie2
echo "Creating MINIMAL conda environment..."
echo "Installing ONLY: FastQC, Trimmomatic, SPAdes, kraken-biom"
echo "(Heavy tools removed - use pre-computed results)"
micromamba create -n metagenomics -y -c bioconda -c conda-forge \
    python=3.9 \
    fastqc=0.12.1 \
    trimmomatic=0.39 \
    spades=3.15.5 \
    kraken-biom=1.2.0

# Aggressively clean up
echo "Cleaning up conda cache..."
micromamba clean -afy

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

# Auto-activate micromamba environment
if ! grep -q "micromamba activate metagenomics" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# Auto-activate metagenomics environment" >> ~/.bashrc
    echo "micromamba activate metagenomics" >> ~/.bashrc
fi

# Create README
cat > ~/README.md << 'EOF'
# Metagenomics Analysis Codespace (Free Tier Optimized)

## Quick Start

### Using the Environment
- **Command-line tools**: `micromamba activate metagenomics` (auto-activated in new terminals)
- All bioinformatics analysis done via command line and scripts

### Tools Installed (Minimal for Free Tier)
- FastQC (quality control)
- Trimmomatic (read trimming)
- MetaSPAdes (assembly - use JC1A sample only!)
- kraken-biom (analyzing pre-computed Kraken2 results)

### NOT Installed (Use Pre-computed Results)
Heavy tools removed to stay under 15GB disk quota:
- ❌ Kraken2 - Use `results/precomputed/taxonomy/*.kraken`
- ❌ MaxBin2 - Use `results/precomputed/binning/`
- ❌ CheckM - Use `results/precomputed/binning/quality_*.tsv`
- ❌ R/RStudio - Removed to save 2GB

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

## Software Installed (Minimal)
- **FastQC, Trimmomatic, MetaSPAdes** (hands-on tools)
- **kraken-biom** (for downstream analysis)

## Disk Usage Strategy
This setup stays under the 15GB free tier limit by:
1. Using micromamba instead of conda (saves 2GB)
2. Removing RStudio/R (saves 2GB)
3. Removing heavy tools: CheckM, MaxBin2, Kraken2 (saves 3.5GB)
4. Using pre-computed results for removed tools

Total saved: ~7.5GB
EOF

echo ""
echo "=== Setup Complete! ==="
echo ""
echo "✅ Minimal tools: FastQC, Trimmomatic, SPAdes, kraken-biom"
echo "✅ Disk usage: ~2GB conda environment (vs. 6.7GB before)"
echo "✅ Workspace: Ready at ~/dc_workshop"
echo ""
echo "⚠️  Heavy tools removed - use pre-computed results!"
echo "📖 See ~/README.md for details"
echo ""
