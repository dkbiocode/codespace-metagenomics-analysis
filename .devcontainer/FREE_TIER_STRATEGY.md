# Free Tier Optimization Strategy

## GitHub Codespaces Free Tier Limits

- **Compute**: 120 core-hours/month = 60 hours on 2-core machine
- **Storage**: 15 GB
- **Machine**: 2-core, 8GB RAM, 32GB disk (default free)

## Resource Analysis by Lesson

### Lesson 01: Background & Metadata
- **Resources**: None (conceptual)
- **Time**: 15 min teaching
- **Storage**: 0 GB

### Lesson 02: Assessing Read Quality (FastQC)
- **Resources**: Low CPU, low memory
- **Time**: ~10 minutes for JC1A (48MB), ~30 min for JP4D (800MB)
- **Storage**: Input: 48-800MB, Output: ~50MB
- **Free tier**: ✅ Works great

### Lesson 03: Trimming and Filtering (Trimmomatic)
- **Resources**: Moderate CPU, low memory
- **Time**: ~5 minutes for JC1A, ~15 min for JP4D
- **Storage**: Input: 48-800MB, Output: ~200-600MB
- **Free tier**: ✅ Works well

### Lesson 04: Assembly (MetaSPAdes)
- **Resources**: HIGH CPU, HIGH memory
- **Time**:
  - JC1A (24MB samples): ~30-60 minutes, ~4GB RAM
  - JP4D (600MB samples): ~4-6 hours, ~12-16GB RAM ❌
- **Storage**: 2-10GB for intermediate K-mer directories
- **Free tier**:
  - ✅ JC1A works on 2-core, 8GB machine
  - ❌ JP4D requires 16-32GB RAM (paid tier)

### Lesson 05: Binning (MaxBin, CheckM)
- **Resources**: Moderate CPU, moderate memory
- **Time**: ~6-7 minutes for MaxBin, ~30 min for CheckM
- **Storage**: ~500MB
- **Free tier**: ✅ Works with JC1A assembly

### Lesson 06: Taxonomic Assignment (Kraken2)
- **Resources**: HIGH memory (8GB minimum for MiniKraken)
- **Time**: ~5-10 minutes with MiniKraken database
- **Storage**: Database: 8GB, Results: ~100MB
- **Free tier**:
  - ⚠️ MiniKraken database (8GB) uses >50% of free storage
  - ⚠️ 8GB RAM is bare minimum
  - **Solution**: Use pre-computed results OR custom smaller database

### Lessons 07-09: R Analysis (Phyloseq, Diversity, Abundance)
- **Resources**: Low CPU, low memory (~1-2GB)
- **Time**: ~2 hours total (interactive learning)
- **Storage**: ~50MB (BIOM files, plots)
- **Free tier**: ✅ Works perfectly in RStudio Server

## Optimization Strategies

### Strategy 1: Use JC1A Sample Only (Recommended for Free Tier)
**What**: Use only the small JC1A sample (24MB × 2 = 48MB compressed)

**Benefits**:
- Assembly completes in 30-60 minutes (vs 4-6 hours)
- Uses 4GB RAM (vs 16GB)
- Saves storage space
- Students still learn all concepts

**Trade-offs**:
- Smaller dataset, less realistic
- Fewer contigs produced
- Less diverse community

**Implementation**:
```bash
# In lessons, replace:
# metaspades.py -1 JP4D_R1.trim.fastq.gz -2 JP4D_R2.trim.fastq.gz -o assembly_JP4D
# With:
metaspades.py -1 JC1A_R1.trim.fastq.gz -2 JC1A_R2.trim.fastq.gz -o assembly_JC1A
```

### Strategy 2: Provide Pre-Computed Results for Heavy Steps
**What**: Include pre-computed outputs for resource-intensive steps

**Files to Pre-Compute**:
1. **Assembly outputs** (Lesson 04):
   - `JP4D_contigs.fasta` (~10MB)
   - `JP4D_scaffolds.fasta` (~10MB)
   - Skip intermediate K-mer directories

2. **Kraken2 outputs** (Lesson 06):
   - `JP4D.kraken` (~200MB)
   - `JP4D.report` (~2MB)
   - Students can run kraken-biom without running Kraken2

3. **MaxBin outputs** (Lesson 05):
   - Pre-binned contigs
   - CheckM quality reports

**Storage Saved**: ~8GB (Kraken database) + 5GB (assembly intermediates) = 13GB

**Benefits**:
- Students can complete all lessons
- Learn the full workflow
- Understand outputs without waiting
- Fits comfortably in 15GB storage

**Trade-offs**:
- Students don't run the most computationally intensive steps themselves
- Can still demonstrate on JC1A if they want hands-on experience

### Strategy 3: Subsample JP4D Reads
**What**: Provide subsampled JP4D reads (e.g., 10% of reads = 60MB)

**Benefits**:
- Students can run all steps
- Faster than full dataset
- More realistic than tiny JC1A

**Trade-offs**:
- Need to create subsampled datasets
- Still more resource-intensive than JC1A

**Implementation**:
```bash
# Subsample to 10% of reads
seqtk sample -s100 JP4D_R1.fastq.gz 0.1 > JP4D_R1.subsample.fastq.gz
seqtk sample -s100 JP4D_R2.fastq.gz 0.1 > JP4D_R2.subsample.fastq.gz
```

## Recommended Implementation

### For Free Tier Users (Default)

**Dataset Approach**:
- Provide JC1A (48MB) as primary dataset
- Provide JP4D pre-computed results in `results/precomputed/`
- Optionally: JP4D subsampled (60MB) as "advanced" option

**Lesson Modifications**:
1. **Lesson 04 (Assembly)**: Default to JC1A, note JP4D pre-computed
2. **Lesson 05 (Binning)**: Use JC1A assembly, reference JP4D results
3. **Lesson 06 (Taxonomy)**: Use pre-computed Kraken2 results for both samples
4. **Lessons 07-09**: Use both JC1A and JP4D Kraken outputs (all pre-computed)

**Storage Budget** (15GB free tier):
```
Codespace OS & base image:     3 GB
RStudio Server & R packages:   2 GB
Conda environment:             3 GB
JC1A raw data:                 0.1 GB
JC1A processed data:           0.5 GB
Pre-computed results:          2 GB
User workspace:                2 GB
Buffer:                        2.4 GB
--------------------------------
Total:                         15 GB
```

**Time Budget** (60 hours free tier):
```
Lessons 1-3:                   2 hours
Lesson 4 (JC1A assembly):      1 hour
Lessons 5-6:                   1 hour
Lessons 7-9:                   2 hours
Students exploring/learning:   54 hours remaining
```

### For Paid Tier Users

**Machine**: 4-core, 16GB RAM (~$0.36/hour)
- Can run full JP4D dataset
- Assembly takes 2-3 hours instead of 4-6
- Can download MiniKraken database (8GB)
- Cost per student: ~$3-5 for full course

## Files to Create

### 1. Sample Data Package (Small)
```
data/
├── untrimmed_fastq/
│   ├── JC1A_R1.fastq.gz       (24 MB)
│   ├── JC1A_R2.fastq.gz       (24 MB)
│   ├── JP41_R1.fastq.gz       (estimated 24 MB)
│   ├── JP41_R2.fastq.gz       (estimated 24 MB)
│   └── TruSeq3-PE.fa          (0.1 MB)
└── README.md
```

### 2. Pre-Computed Results Package
```
results/precomputed/
├── assembly/
│   ├── JP4D_contigs.fasta     (10 MB)
│   └── JP4D_scaffolds.fasta   (10 MB)
├── taxonomy/
│   ├── JC1A.kraken            (50 MB)
│   ├── JC1A.report            (1 MB)
│   ├── JP4D.kraken            (200 MB)
│   ├── JP4D.report            (2 MB)
│   ├── JP41.kraken            (50 MB)
│   └── JP41.report            (1 MB)
├── binning/
│   └── JP4D_bins/
│       ├── JP4D.001.fasta
│       ├── JP4D.002.fasta
│       └── quality_JP4D.tsv
└── README.md
```

### 3. Download Scripts
```bash
# data/download_full_dataset.sh
# For users who want to download JP4D (paid tier recommended)

# data/download_precomputed.sh
# For users who want pre-computed results (free tier)
```

## Testing Checklist

- [ ] Codespace builds successfully on free tier (2-core)
- [ ] RStudio Server accessible at port 8787
- [ ] Conda environment activates correctly
- [ ] FastQC runs on JC1A in <10 minutes
- [ ] Trimmomatic runs on JC1A in <5 minutes
- [ ] MetaSPAdes runs on JC1A in <60 minutes with 8GB RAM
- [ ] R packages load in RStudio
- [ ] Phyloseq analysis works with pre-computed Kraken results
- [ ] Total storage usage < 12 GB
- [ ] All lessons completable in <10 hours total

## Documentation Updates Needed

### Lesson 04: Assembly
Add callout box:
```markdown
> ## Free Tier Note
> The JP4D sample (600MB) requires 16GB+ RAM for assembly, which exceeds
> the free tier. We recommend using the JC1A sample (24MB) which assembles
> in ~30 minutes on a 2-core machine. Pre-computed JP4D assembly results
> are provided in `results/precomputed/assembly/`.
```

### Lesson 06: Taxonomic Assignment
Add callout box:
```markdown
> ## Free Tier Note
> Kraken2 requires an 8GB database and 8GB+ RAM. To save time and space,
> we provide pre-computed Kraken2 results in `results/precomputed/taxonomy/`.
> You can proceed directly to using kraken-biom with these results.
```

## Summary

**Free Tier Users** (2-core, 8GB RAM, 15GB storage):
- Use JC1A for hands-on assembly (~1 hour)
- Use pre-computed results for JP4D
- Complete all analysis steps in R
- **Total cost**: $0
- **Total time**: 6-8 hours

**Paid Tier Users** (4-core, 16GB RAM):
- Can run full JP4D assembly (2-3 hours)
- Can download and use MiniKraken database
- Full hands-on experience
- **Total cost**: ~$3-5 per student
- **Total time**: 10-15 hours
