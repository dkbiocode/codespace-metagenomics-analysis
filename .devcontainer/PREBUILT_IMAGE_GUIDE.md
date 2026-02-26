# Pre-built Image Deployment Guide

This guide walks you through building and deploying a pre-built container image for instant Codespace startup.

## Why Use a Pre-built Image?

**Current setup problems:**
- 237 MB of binary files in git repo
- 10-15 minute setup.sh on every Codespace creation
- If phyloseq install fails, users see errors
- Each Codespace rebuilds the same environment

**Pre-built image benefits:**
- ✅ Git repo shrinks to ~5 MB (remove binaries)
- ✅ Codespace starts in ~1-2 minutes (vs 10-15 min)
- ✅ Guaranteed working phyloseq installation
- ✅ Saves ~500 MB disk per Codespace
- ✅ You fix issues before users see them

---

## Step-by-Step Deployment

### Phase 1: Build and Test Locally (Mac with Docker Desktop)

#### 1. Set Your GitHub Username

```bash
export GITHUB_USERNAME="your-actual-username"
```

Replace `your-actual-username` with your GitHub username.

#### 2. Build the Image Locally

```bash
cd .devcontainer
./build-and-push.sh build
```

**What this does:**
- Builds Docker image with your working phyloseq binaries
- Tests that phyloseq loads correctly
- Takes 10-15 minutes (phyloseq installation is slow)

**Expected output:**
```
📦 Building Docker image locally...
...
✅ Image built successfully!
🧪 Testing image...
✅ phyloseq works!
```

#### 3. Test the Image Locally (Optional but Recommended)

Run RStudio Server from the local image:

```bash
docker run --rm -p 8787:8787 \
  -e DISABLE_AUTH=true \
  metagenomics-codespace:latest
```

Open http://localhost:8787 and test:
```r
library(phyloseq)
library(ggplot2)
data(GlobalPatterns)
plot_richness(GlobalPatterns, measures=c("Shannon"))
```

Press Ctrl+C to stop when done.

---

### Phase 2: Push to GitHub Container Registry

#### 4. Authenticate with GitHub Container Registry

```bash
# Create a Personal Access Token (PAT):
# 1. Go to: https://github.com/settings/tokens
# 2. Click "Generate new token (classic)"
# 3. Select scopes: write:packages, read:packages, delete:packages
# 4. Copy the token

# Login to ghcr.io
docker login ghcr.io -u YOUR_USERNAME
# Paste your token when prompted for password
```

#### 5. Push the Image

```bash
./build-and-push.sh push
```

**What this does:**
- Pushes your local image to `ghcr.io/YOUR_USERNAME/metagenomics-codespace:latest`
- Makes it available for Codespaces to pull

#### 6. Make the Image Public (Important!)

By default, GitHub Container Registry images are private.

1. Go to: https://github.com/YOUR_USERNAME?tab=packages
2. Find `metagenomics-codespace`
3. Click on it → Package settings
4. Scroll to "Danger Zone"
5. Click "Change visibility" → "Public"

This allows Codespaces to pull the image without authentication.

---

### Phase 3: Update Your Repository

#### 7. Update devcontainer.json

Edit the image name in `devcontainer.prebuilt.json`:

```json
{
  "image": "ghcr.io/YOUR_ACTUAL_USERNAME/metagenomics-codespace:latest",
  ...
}
```

Then replace your current `devcontainer.json`:

```bash
cd /path/to/repo
mv .devcontainer/devcontainer.json .devcontainer/devcontainer.old.json
mv .devcontainer/devcontainer.prebuilt.json .devcontainer/devcontainer.json
```

#### 8. (Optional) Remove Binaries from Repo

**WARNING**: Only do this AFTER confirming the pre-built image works in a Codespace!

```bash
# Create a new branch for safety
git checkout -b prebuilt-image

# Remove binaries
rm -rf binaries/

# Update .gitignore to keep binaries out
echo "binaries/" >> .gitignore

# Commit
git add .
git commit -m "Switch to pre-built container image

- Remove 237MB of R package binaries from repo
- Install R packages in Docker image instead
- Reduces Codespace startup from 10-15 min to 1-2 min
- Saves ~500MB disk per Codespace"

git push -u origin prebuilt-image
```

---

### Phase 4: Test in Codespaces

#### 9. Create Test Codespace

1. Go to your GitHub repo
2. Click "Code" → "Codespaces" → "New codespace"
3. Select the `prebuilt-image` branch
4. Click "Create codespace"

**Expected timeline:**
- Container pulls: ~1-2 min (pulling pre-built image)
- setup-minimal.sh: ~10 min (conda environment only)
- **Total: ~11-12 min vs 25+ min before**

#### 10. Verify Everything Works

In the Codespace terminal:
```bash
# Check conda
conda activate metagenomics
fastqc --version

# Check R packages
R -e "library(phyloseq); library(ggplot2)"
```

Open RStudio Server (http://localhost:8787):
```r
library(phyloseq)
data(GlobalPatterns)
plot_richness(GlobalPatterns, x="SampleType", measures=c("Shannon", "Simpson"))
```

If everything works, merge the `prebuilt-image` branch to `main`!

---

## Automated Rebuilds (Optional)

### Phase 5: GitHub Actions for Auto-rebuilds

When you update R packages or dependencies, you need to rebuild the image.

Create `.github/workflows/build-image.yml`:

```yaml
name: Build and Push Container Image

on:
  push:
    branches: [main]
    paths:
      - '.devcontainer/Dockerfile.prebuilt'
      - '.github/workflows/build-image.yml'
  workflow_dispatch:  # Manual trigger

jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - uses: actions/checkout@v4

      - name: Log in to GitHub Container Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Build and push Docker image
        uses: docker/build-push-action@v5
        with:
          context: .
          file: .devcontainer/Dockerfile.prebuilt
          push: true
          tags: |
            ghcr.io/${{ github.repository_owner }}/metagenomics-codespace:latest
            ghcr.io/${{ github.repository_owner }}/metagenomics-codespace:${{ github.sha }}
```

Now, whenever you update `Dockerfile.prebuilt`, GitHub Actions automatically rebuilds and pushes the image!

---

## Disk Usage Comparison

### Before (current setup):
```
Base rocker/rstudio:4.3     3-4 GB
setup.sh apt packages       0.5 GB
setup.sh R packages         0.5 GB
Build artifacts/cache       0.3 GB
Conda environment           2-3 GB
User workspace              2 GB
--------------------------------
Total per Codespace:        8-10 GB
```

### After (pre-built image):
```
Pre-built image layer       4-4.5 GB (shared across Codespaces)
Conda environment           2-3 GB
User workspace              2 GB
--------------------------------
Total per Codespace:        6-7.5 GB
Savings:                    1.5-2.5 GB per Codespace
```

**With 15 GB free tier, users can now run 2-3 Codespaces instead of 1-2!**

---

## Troubleshooting

### Build fails with "No space left on device"
Docker Desktop → Preferences → Resources → Increase disk image size to 100 GB

### "authentication required" when creating Codespace
Image is still private. Go to https://github.com/USERNAME?tab=packages and make it public.

### phyloseq fails to load in image
Rebuild locally and check logs. The Dockerfile runs `R -e "library(phyloseq)"` which fails the build if broken.

### Want to update R packages?
Edit `Dockerfile.prebuilt`, rebuild locally, push new image. Existing Codespaces won't auto-update (need to rebuild Codespace).

---

## Next Steps

1. **Build locally** to verify it works on your Mac
2. **Push to GHCR** to make it available
3. **Test in a Codespace** before removing binaries
4. **Set up GitHub Actions** for automatic rebuilds (optional)
5. **Update documentation** to reflect faster startup times

Questions? Check the troubleshooting section or open an issue!
