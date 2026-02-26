# Quick Start: Pre-built Image Deployment

## TL;DR - Commands to Run

### On Your Mac (Docker Desktop)

```bash
# 1. Set your GitHub username
export GITHUB_USERNAME="your-github-username"

# 2. Build the image locally (takes 10-15 min)
cd .devcontainer
./build-and-push.sh build

# 3. Test it (optional but recommended)
docker run --rm -p 8787:8787 -e DISABLE_AUTH=true metagenomics-codespace:latest
# Open http://localhost:8787 and test: library(phyloseq)
# Press Ctrl+C when done

# 4. Login to GitHub Container Registry
# First, create a token: https://github.com/settings/tokens (write:packages scope)
docker login ghcr.io -u YOUR_USERNAME
# Paste token when prompted

# 5. Push the image
./build-and-push.sh push

# 6. Make image public
# Go to: https://github.com/YOUR_USERNAME?tab=packages
# Find "metagenomics-codespace" → Package settings → Change visibility → Public
```

### Update Your Repo

```bash
# 7. Update devcontainer.json to use the image
cd /path/to/repo
# Edit .devcontainer/devcontainer.prebuilt.json - replace YOUR_USERNAME
# Then:
cp .devcontainer/devcontainer.json .devcontainer/devcontainer.old.json
cp .devcontainer/devcontainer.prebuilt.json .devcontainer/devcontainer.json

# 8. Commit and push
git add .devcontainer/
git commit -m "Switch to pre-built container image"
git push
```

### Test in Codespaces

```bash
# 9. Create a Codespace from your repo
# Should start in ~11-12 min instead of 25+ min
# R packages pre-installed, no binaries to install!
```

---

## What You Get

### Before
- ⏱️ 25+ minute Codespace startup
- 💾 8-10 GB disk per Codespace
- 📦 237 MB git repo (binaries)
- 🐛 phyloseq install can fail

### After
- ⏱️ 11-12 minute Codespace startup (10-15 min faster!)
- 💾 6-7.5 GB disk per Codespace (1.5-2.5 GB saved)
- 📦 5 MB git repo (after removing binaries)
- ✅ phyloseq guaranteed working (tested in image build)

### Result
**Users can run 2-3 Codespaces within 15 GB free tier instead of 1-2!**

---

## Files Created

- `Dockerfile.prebuilt` - Docker image with phyloseq baked in
- `build-and-push.sh` - Script to build/test/push image
- `devcontainer.prebuilt.json` - Config to use pre-built image
- `setup-minimal.sh` - Fast setup (conda only, no R install)
- `PREBUILT_IMAGE_GUIDE.md` - Full detailed guide
- `.github/workflows/build-container-image.yml` - Auto-rebuild on changes

---

## Troubleshooting

**"No space left on device" during build**
→ Docker Desktop → Settings → Resources → Increase disk to 100 GB

**Codespace says "authentication required"**
→ Make image public: github.com/YOUR_USERNAME?tab=packages

**phyloseq doesn't load in image**
→ Check build logs, the build fails if phyloseq broken

---

## Questions?

See `PREBUILT_IMAGE_GUIDE.md` for detailed step-by-step instructions.
