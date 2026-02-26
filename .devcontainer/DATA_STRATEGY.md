# Data Distribution Strategy for Metagenomics Codespace

## Current Situation

Your lessons are adapted from Data Carpentry's metagenomics workshop, which originally:
- Used AWS cloud instances
- Had data pre-loaded on the instances
- Referenced paths like `~/dc_workshop/data/...`

## Problem

- Lessons reference data files (FASTQ, BIOM, etc.) but don't explain where to get them
- CODESPACE_SETUP.md mentions SRA downloads but is vague
- No clear Zenodo link or data repository specified
- Students won't know how to obtain the required files

## Recommended Solutions

### Option 1: Zenodo Dataset (RECOMMENDED)

**Create a Zenodo dataset with:**
1. **JC1A sample** (small, ~48 MB compressed)
   - `JC1A_R1.fastq.gz`
   - `JC1A_R2.fastq.gz`
   - For hands-on lessons 1-4

2. **Pre-computed results** (~200-500 MB)
   - Kraken2 outputs: `JC1A.kraken`, `JC1A.report`, `JP4D.kraken`, `JP4D.report`
   - kraken-biom output: `cuatroc.biom` (for R lessons 7-9)
   - Assembly outputs: `JP4D_contigs.fasta`
   - MaxBin outputs: `JP4D.001.fasta`, etc.

**Advantages:**
- ✅ Free, permanent DOI
- ✅ Fast downloads
- ✅ Citable in publications
- ✅ Students get same data as instructor
- ✅ Works worldwide (no geo-restrictions)

**How to create:**
1. Go to https://zenodo.org/
2. Create account (can link GitHub)
3. Upload → New upload
4. Add files, description, license (CC0 or CC-BY)
5. Publish → Get DOI
6. Update `download_data.sh` with Zenodo URL

**Example download script:**
```bash
#!/bin/bash
cd ~/dc_workshop/data/untrimmed_fastq

# Download from Zenodo
wget https://zenodo.org/record/XXXXXX/files/JC1A_samples.tar.gz
tar -xzf JC1A_samples.tar.gz
rm JC1A_samples.tar.gz

echo "✅ Sample data downloaded!"
```

### Option 2: GitHub Releases

Store data in GitHub Releases (max 2 GB per file):

```bash
# In download_data.sh
REPO="meekrob/codespace-metagenomics-analysis"
VERSION="v1.0.0"

wget https://github.com/${REPO}/releases/download/${VERSION}/JC1A_samples.tar.gz
tar -xzf JC1A_samples.tar.gz
```

**Advantages:**
- ✅ Same repository
- ✅ Version controlled with tags
- ✅ Free for public repos

**Disadvantages:**
- ❌ 2 GB per file limit
- ❌ Less discoverable than Zenodo
- ❌ No DOI

### Option 3: SRA Direct Download

Point students to SRA accessions:

```bash
# In download_data.sh
# Install sra-toolkit if needed
conda install -c bioconda sra-tools

# Download JC1A
fastq-dump --split-files --gzip ERS1949784
mv ERS1949784_1.fastq.gz JC1A_R1.fastq.gz
mv ERS1949784_2.fastq.gz JC1A_R2.fastq.gz
```

**Advantages:**
- ✅ Original data source
- ✅ No hosting needed

**Disadvantages:**
- ❌ Slow downloads
- ❌ Requires sra-tools installation
- ❌ Can fail/timeout
- ❌ No pre-computed results

### Option 4: Hybrid Approach (BEST)

**Combine Zenodo + SRA:**

1. **Zenodo hosts:**
   - Pre-computed results (biom files, kraken outputs)
   - Small test dataset (JC1A)
   - Trimmomatic adapters

2. **SRA for advanced users:**
   - Optional larger datasets
   - Those who want to download from source

3. **In setup.sh:**
   - Auto-download small essentials (adapters)
   - Provide script for Zenodo data
   - Provide alternative SRA instructions

## Files Students Need

### Minimal (Lessons 7-9, R analysis only)
- `cuatroc.biom` (~5 MB) - For phyloseq lessons
- **Total: ~5 MB**

### Standard (JC1A hands-on)
- `JC1A_R1.fastq.gz` + `JC1A_R2.fastq.gz` (~48 MB)
- `TruSeq3-PE.fa` (adapters, ~1 KB)
- Pre-computed `cuatroc.biom` for R lessons
- **Total: ~50 MB**

### Full (Advanced users, paid tier)
- All JC1A files
- JP4D samples (~800 MB)
- Pre-computed results for comparison
- **Total: ~1 GB**

## Recommended Implementation

### Step 1: Package Data for Zenodo

Create three archives:

**1. `metagenomics-minimal.tar.gz` (~5 MB)**
```
minimal/
└── taxonomy/
    └── cuatroc.biom
```

**2. `metagenomics-jc1a.tar.gz` (~50 MB)**
```
jc1a/
├── data/
│   └── untrimmed_fastq/
│       ├── JC1A_R1.fastq.gz
│       ├── JC1A_R2.fastq.gz
│       └── TruSeq3-PE.fa
└── taxonomy/
    └── cuatroc.biom
```

**3. `metagenomics-precomputed.tar.gz` (~500 MB)**
```
precomputed/
├── assembly/
│   ├── JP4D_contigs.fasta
│   └── JP4D_scaffolds.fasta
├── taxonomy/
│   ├── JC1A.kraken
│   ├── JC1A.report
│   ├── JP4D.kraken
│   ├── JP4D.report
│   └── cuatroc.biom
└── binning/
    ├── JP4D.001.fasta
    └── quality_JP4D.tsv
```

### Step 2: Update setup-updated.sh

Use the new script that:
- Creates `~/dc_workshop/` as symlink to repo
- Downloads adapters automatically
- Provides `download_data.sh` helper
- Points students to Zenodo

### Step 3: Update Lessons

Add at the beginning of lesson 02 (first hands-on):

```markdown
## Getting Sample Data

Before starting, download the sample data:

```bash
cd ~/dc_workshop/data
./download_data.sh
```

This downloads the JC1A sample (48 MB) from Zenodo.

Alternatively, for R analysis only (lessons 7-9), you only need the minimal dataset.
```

### Step 4: Update CODESPACE_SETUP.md

Replace the vague "Getting Sample Data" section (lines 197-216) with:

```markdown
## Getting Sample Data

### Quick Start (Recommended)

```bash
cd ~/dc_workshop/data
./download_data.sh
```

This downloads sample data from Zenodo:
- **JC1A sample** (48 MB) - For hands-on lessons 1-6
- **Pre-computed results** - For R lessons 7-9

### Manual Download

Visit our Zenodo repository: [https://doi.org/10.5281/zenodo.XXXXXX](https://doi.org/10.5281/zenodo.XXXXXX)

Choose your dataset:
1. **Minimal** (~5 MB) - R lessons only
2. **Standard** (~50 MB) - Full workshop with JC1A
3. **Advanced** (~1 GB) - Includes larger samples

### From SRA (Advanced)

```bash
conda install -c bioconda sra-tools
cd ~/dc_workshop/data/untrimmed_fastq
fastq-dump --split-files --gzip ERS1949784
mv ERS1949784_1.fastq.gz JC1A_R1.fastq.gz
mv ERS1949784_2.fastq.gz JC1A_R2.fastq.gz
```
```

## Action Items

- [ ] Create Zenodo account
- [ ] Package data files (minimal, standard, precomputed)
- [ ] Upload to Zenodo and get DOI
- [ ] Update `setup-updated.sh` with Zenodo URL
- [ ] Replace `.devcontainer/setup.sh` with `setup-updated.sh`
- [ ] Update `CODESPACE_SETUP.md` with data instructions
- [ ] Add data download step to lesson 02
- [ ] Test full workflow in Codespace
- [ ] Document data provenance in Zenodo description

## Questions to Resolve

1. **Do you have the actual data files?**
   - JC1A FASTQ files
   - cuatroc.biom file
   - Pre-computed results

2. **Where did they originally come from?**
   - SRA accessions?
   - Data Carpentry's AWS instance?
   - Generated yourself?

3. **Can you share them?**
   - Licensing/permissions okay?
   - Can redistribute via Zenodo?

4. **What's in cuatroc.biom?**
   - Which samples does it contain?
   - Was it generated from JC1A + JP4D + others?

Once you have the data files, I can help you package and upload to Zenodo!
