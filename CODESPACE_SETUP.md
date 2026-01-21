# GitHub Codespace Setup for Metagenomics Analysis

This repository is configured to run in **GitHub Codespaces** with RStudio Server, providing a complete metagenomics analysis environment in your browser.

## Quick Start

### 1. Create a Codespace

**Via GitHub Web Interface:**
1. Go to this repository on GitHub
2. Click the green **"Code"** button
3. Select the **"Codespaces"** tab
4. Click **"Create codespace on main"**

The first build will take **20-30 minutes** as it installs all software.

### 2. Access RStudio Server

Once the Codespace is running:
1. Look for the **"Ports"** tab in VS Code (bottom panel)
2. Find port **8787** (labeled "RStudio Server")
3. Click the **globe icon** 🌐 or the local address to open RStudio in a new browser tab

**Login credentials:**
- Username: `rstudio`
- Password: `metagenomics`

(Or if authentication is disabled, you'll go straight to RStudio)

### 3. Start Working

In RStudio, you'll see:
- **Console** (bottom-left): R commands start with `>`
- **Terminal** (bottom-left, separate tab): Bash commands start with `$`
- **Script Editor** (top-left): Write and save R scripts
- **Plots** (bottom-right): View ggplot2 visualizations
- **Files** (bottom-right): Browse your workspace

The conda environment `metagenomics` is **automatically activated** in new terminals.

## What's Included

### Software Installed:
- **R 4.3** with RStudio Server
- **FastQC 0.12.1** - Quality control
- **Trimmomatic 0.39** - Read trimming
- **MetaSPAdes 3.15.5** - Metagenome assembly
- **MaxBin2 2.2.7** - Binning
- **CheckM 1.2.2** - Quality assessment
- **Kraken2 2.1.3** - Taxonomic classification
- **Krona 2.8.1** - Visualization
- **kraken-biom 1.2.0** - Format conversion

### R Packages:
- **phyloseq** - Metagenome analysis
- **ggplot2** - Plotting
- **RColorBrewer** - Color palettes
- **patchwork** - Multi-panel plots
- **vegan** - Diversity analysis

### Directory Structure:
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

## Free Tier Optimization

This Codespace is optimized for **GitHub Free tier** (60 hours/month on 2-core machine):

### Recommended Approach:
1. **Use JC1A sample** (24MB) for hands-on learning
   - Assembly: ~30-60 minutes ✅
   - Memory: ~4GB ✅

2. **Use pre-computed results** for JP4D (large sample)
   - Located in `results/precomputed/`
   - Kraken2 outputs, assemblies, bins

3. **Skip Kraken2 database download**
   - Uses 8GB storage + 8GB RAM
   - Pre-computed results provided

### Estimated Time Usage:
- Lessons 1-3 (QC, Trimming): 2 hours
- Lesson 4 (Assembly with JC1A): 1 hour
- Lessons 5-6 (Binning, Taxonomy): 1 hour
- Lessons 7-9 (R Analysis): 2 hours
- **Total: 6-8 hours** (52+ hours remaining for exploration)

See `.devcontainer/FREE_TIER_STRATEGY.md` for detailed information.

## Basic Workflow

### In RStudio Terminal (for bash commands):

```bash
# Navigate to data directory
cd ~/dc_workshop/data/untrimmed_fastq

# Run FastQC
fastqc *.fastq.gz

# Run Trimmomatic
trimmomatic PE JC1A_R1.fastq.gz JC1A_R2.fastq.gz \
    JC1A_R1.trim.fastq.gz JC1A_R1un.trim.fastq.gz \
    JC1A_R2.trim.fastq.gz JC1A_R2un.trim.fastq.gz \
    SLIDINGWINDOW:4:20 MINLEN:35 \
    ILLUMINACLIP:TruSeq3-PE.fa:2:40:15

# Run assembly (use screen for long processes)
screen -S assembly
cd ~/dc_workshop/data/trimmed_fastq
metaspades.py -1 JC1A_R1.trim.fastq.gz -2 JC1A_R2.trim.fastq.gz \
    -o ../../results/assembly_JC1A
# Press Ctrl+A, then D to detach from screen
```

### In RStudio Console (for R commands):

```r
# Load packages
library(phyloseq)
library(ggplot2)

# Load data
biomfile_name <- "~/dc_workshop/taxonomy/cuatroc.biom"
biomfile <- import_biom(biomfile_name)

# Analysis and plotting...
```

## Troubleshooting

### RStudio Not Accessible
1. Check **Ports** tab in VS Code
2. Verify port 8787 is listed
3. Try clicking the globe icon 🌐
4. If still not working:
   ```bash
   sudo rstudio-server restart
   ```

### Conda Environment Not Active
```bash
conda activate metagenomics
```

Or add to your `~/.bashrc`:
```bash
echo "conda activate metagenomics" >> ~/.bashrc
source ~/.bashrc
```

### Software Not Found
```bash
# Check conda environment
conda env list

# Ensure metagenomics is active
conda activate metagenomics

# Check tool versions
fastqc --version
metaspades.py --version
```

### Out of Storage
```bash
# Check usage
df -h

# Clean conda cache
conda clean --all -y

# Remove large intermediate files
rm -rf ~/dc_workshop/results/assembly_*/K*/
```

### R Packages Not Loading
```r
# In R console
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("phyloseq")
```

## Getting Sample Data

### Option 1: Download from SRA (requires SRA Toolkit)
```bash
cd ~/dc_workshop/data/untrimmed_fastq

# Download JC1A (recommended for free tier)
fastq-dump --split-files --gzip ERS1949784

# Rename to match lesson expectations
mv ERS1949784_1.fastq.gz JC1A_R1.fastq.gz
mv ERS1949784_2.fastq.gz JC1A_R2.fastq.gz
```

### Option 2: Use Provided Data
Check if sample data is included in the repository under `data/`.

### Option 3: Download Pre-Computed Results
Located in `results/precomputed/` - allows you to skip resource-intensive steps.

## Stopping Your Codespace

**Important**: Codespaces **consume hours when running**, even if idle!

To stop your Codespace:
1. Go to https://github.com/codespaces
2. Find your active Codespace
3. Click **"⋯"** (three dots) → **"Stop codespace"**

Or use GitHub CLI:
```bash
gh codespace stop
```

The Codespace and all your files are **preserved** when stopped and can be restarted later.

## Deleting a Codespace

To permanently delete (frees up storage):
1. Go to https://github.com/codespaces
2. Click **"⋯"** → **"Delete"**

## Advanced: Customizing the Devcontainer

The Codespace configuration is in `.devcontainer/`:
- `devcontainer.json` - Container settings
- `setup.sh` - Installation script
- `FREE_TIER_STRATEGY.md` - Optimization notes

To modify:
1. Edit files locally
2. Commit and push changes
3. **Rebuild Container**: Command Palette (Cmd/Ctrl+Shift+P) → "Codespaces: Rebuild Container"

## Resources

- **Lessons**: See `lessons/` directory
- **GitHub Codespaces Docs**: https://docs.github.com/en/codespaces
- **RStudio Server**: https://posit.co/products/open-source/rstudio-server/
- **Phyloseq Tutorial**: https://joey711.github.io/phyloseq/

## Support

For issues with:
- **Software/Tools**: Check `.devcontainer/DEPLOYMENT_CHECKLIST.md`
- **Lessons**: Open an issue in this repository
- **Codespaces**: See GitHub Codespaces documentation

---

**Happy analyzing!** 🧬
