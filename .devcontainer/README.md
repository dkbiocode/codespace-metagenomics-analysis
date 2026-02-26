# Metagenomics Analysis Codespace - Development Container

This directory contains the Docker configuration for the Metagenomics Analysis training environment.

## Quick Start

**For students:** Just create a Codespace - everything is pre-configured!

**For instructors:** See below for maintaining and updating the environment.

---

## Architecture: Pre-built Container Image

This Codespace uses a **pre-built Docker image** hosted on GitHub Container Registry:

**Image:** `ghcr.io/meekrob/metagenomics-codespace:latest`

### Why Pre-built?

**Benefits:**
- ✅ Faster startup: ~11-12 min (vs 25+ min with on-the-fly builds)
- ✅ Lower disk usage: 6-7.5 GB per Codespace (vs 8-10 GB)
- ✅ Reliable: phyloseq installation tested before students see it
- ✅ Free tier friendly: Students can run 2-3 Codespaces in 15 GB limit

**Trade-offs:**
- Need to rebuild image when R packages change
- Image maintenance required (but automated with GitHub Actions)

---

## File Structure

```
.devcontainer/
├── devcontainer.json         # Main config - uses pre-built image
├── Dockerfile                # Image build definition (for rebuilding)
├── setup.sh                  # Minimal setup (conda only, ~10 min)
├── build-and-push.sh         # Script to rebuild and push image
├── PREBUILT_IMAGE_GUIDE.md   # Full guide for maintaining image
├── QUICK_START.md            # TL;DR for rebuilding
├── old-build-method/         # Archived original build files
└── .github/workflows/        # Auto-rebuild on changes
```

---

## For Instructors: Updating the Environment

### When to Rebuild the Image

Rebuild when you:
- Update R package versions
- Add/remove R packages
- Update system dependencies
- Update base image (rocker/rstudio)

### How to Rebuild (Local)

**Prerequisites:**
- Docker Desktop installed
- GitHub Personal Access Token with `write:packages` scope

**Steps:**

1. **Make changes to `Dockerfile`**
   ```bash
   # Edit .devcontainer/Dockerfile
   # Example: Add a new R package
   ```

2. **Build locally and test**
   ```bash
   cd .devcontainer
   ./build-and-push.sh build

   # Test locally (optional)
   docker run --rm -p 8787:8787 -e DISABLE_AUTH=true metagenomics-codespace:latest
   # Open http://localhost:8787 and verify changes
   ```

3. **Push to GitHub Container Registry**
   ```bash
   docker login ghcr.io -u meekrob
   ./build-and-push.sh push
   ```

4. **Test in Codespaces**
   - Create a new Codespace from your repo
   - Verify everything works
   - Existing Codespaces won't auto-update (users need to rebuild)

**See `PREBUILT_IMAGE_GUIDE.md` for detailed instructions.**

### How to Rebuild (Automated)

GitHub Actions automatically rebuilds the image when:
- `Dockerfile` changes
- `binaries/` directory changes
- Manual trigger via GitHub UI

**Workflow:** `.github/workflows/build-container-image.yml`

---

## Image Contents

### Base Image
- `rocker/rstudio:4.3` - R 4.3 + RStudio Server

### System Dependencies
- Build tools: gcc, make, etc.
- Bioinformatics dependencies: HDF5, GLPK, libxml2, libcurl
- Utilities: wget, curl, git, screen, nano

### R Packages (Pre-installed)
- **Metagenomics:** phyloseq, biomformat, Biostrings
- **Visualization:** ggplot2, RColorBrewer, patchwork
- **Analysis:** vegan, ade4, ape
- **Bioconductor infrastructure:** BiocManager, S4Vectors, IRanges, etc.

### Conda Environment (Installed at Codespace creation)
- FastQC, Trimmomatic, MetaSPAdes
- Bowtie2, Kraken2, MaxBin2, CheckM
- kraken-biom

---

## Troubleshooting

### Image won't pull in Codespaces
**Problem:** "authentication required" or "manifest unknown"

**Solution:** Make sure image is public:
1. Go to https://github.com/meekrob?tab=packages
2. Click "metagenomics-codespace"
3. Package settings → Change visibility → Public

### phyloseq fails to load
**Problem:** `library(phyloseq)` errors in RStudio

**Solution:**
1. Check that you're using the latest image
2. Rebuild the image locally to test:
   ```bash
   ./build-and-push.sh build
   docker run --rm metagenomics-codespace:latest R -e "library(phyloseq)"
   ```
3. If still failing, check binaries in `binaries/` directory

### Need to roll back to old method
**Problem:** Pre-built image not working, need quick fix

**Solution:**
```bash
cd .devcontainer
cp old-build-method/* .
git add .
git commit -m "Temporarily revert to old build method"
git push
```

---

## Contributing

When making changes:
1. Test locally first with `./build-and-push.sh build`
2. Verify phyloseq loads: `docker run ... R -e "library(phyloseq)"`
3. Push to GHCR
4. Test in a Codespace
5. Only then commit and push to main

---

## Resources

- **Pre-built Image Guide:** `PREBUILT_IMAGE_GUIDE.md`
- **Quick Start:** `QUICK_START.md`
- **GitHub Container Registry:** https://github.com/meekrob?tab=packages
- **Rocker Project:** https://rocker-project.org/
- **phyloseq:** https://joey711.github.io/phyloseq/
