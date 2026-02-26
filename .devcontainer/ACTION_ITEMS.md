# Action Items Checklist

## ✅ Completed Today

- [x] Built pre-built container image with phyloseq
- [x] Pushed image to ghcr.io/meekrob/metagenomics-codespace:latest
- [x] Made image public on GitHub Packages
- [x] Created RStudio project file for easy navigation
- [x] Created symlinks for lesson access in RStudio
- [x] Created WELCOME.md with user instructions
- [x] Added rmarkdown packages for .md preview in RStudio
- [x] Tested locally - lessons accessible, phyloseq works
- [x] Created GitHub Actions workflow for auto-rebuilds
- [x] Documented entire deployment process

## 📋 Ready to Deploy (When You Want)

### Option A: Deploy Now (Recommended)

```bash
cd /Users/david/work/codespace-metagenomics-analysis

# 1. Replace setup.sh with updated version
cp .devcontainer/setup-updated.sh .devcontainer/setup.sh

# 2. Rebuild image with rmarkdown packages
cd .devcontainer
./build-and-push.sh build
./build-and-push.sh push

# 3. Commit and push everything
cd ..
git add .
git commit -m "Deploy pre-built image with lesson access and rmarkdown support"
git push
```

**Result:** Next Codespace will be ready with all improvements!

### Option B: Wait and Test More

Continue testing locally, then deploy when confident.

## 🔄 When Codespaces Usage Resets

### First Test Codespace

1. **Create Codespace from your repo**
2. **Time the startup** (should be ~11-12 min)
3. **Open RStudio** (http://localhost:8787)
4. **Verify:**
   - [ ] WELCOME.md opens automatically
   - [ ] Files panel shows `lessons/`, `dc_workshop/`, `fig/`
   - [ ] Can click `lessons/07-phyloseq.md` and preview renders
   - [ ] `library(phyloseq)` works without installation
   - [ ] `library(rmarkdown)` works
   - [ ] `setwd("~/dc_workshop/taxonomy/")` works
5. **Test a lesson:**
   - [ ] Open `lessons/07-phyloseq.md`
   - [ ] Copy R commands
   - [ ] Paste into Console
   - [ ] Commands work

### If Everything Works

- [ ] Document actual startup time
- [ ] Update CODESPACE_SETUP.md with new info
- [ ] Consider adding conda to image (final optimization)

### If Issues Found

- [ ] Document the issue
- [ ] Fix locally
- [ ] Rebuild and push image
- [ ] Test again

## 📦 Data Distribution (When Ready)

### Create Zenodo Dataset

1. **Gather files:**
   - [ ] JC1A_R1.fastq.gz, JC1A_R2.fastq.gz (~48 MB)
   - [ ] cuatroc.biom (for R lessons)
   - [ ] Pre-computed results (optional)

2. **Upload to Zenodo:**
   - [ ] Create account at https://zenodo.org
   - [ ] Upload → New upload
   - [ ] Add description, license (CC0 or CC-BY)
   - [ ] Publish → Get DOI

3. **Update setup.sh:**
   - [ ] Add Zenodo download URL to `download_data.sh`
   - [ ] Test download works
   - [ ] Commit and push

4. **Update lessons:**
   - [ ] Add data download step to lesson 02
   - [ ] Remove AWS references
   - [ ] Update CODESPACE_SETUP.md

## 🚀 Final Optimizations (Optional)

### Bake Conda into Image

For ultimate speed (~1-2 min startup):

1. **Create conda lock file:**
   ```bash
   conda list --explicit > conda-lock.txt
   ```

2. **Update Dockerfile:**
   ```dockerfile
   # Add micromamba
   # Copy conda-lock.txt
   # Create environment in image
   ```

3. **Update setup.sh:**
   ```bash
   # Remove conda installation
   # Just create symlinks and download data
   ```

**Result:** 11 min → 1-2 min startup!

### Remove Binaries from Repo (Optional)

If you want to clean git history:

1. **Use git-filter-repo:**
   ```bash
   git filter-repo --path binaries/ --invert-paths
   ```

2. **Force push:**
   ```bash
   git push origin --force --all
   ```

**Warning:** Rewrites history, breaks existing clones!

## 📊 Success Metrics

Once deployed, track:

- **Startup time:** Target < 12 minutes
- **Disk usage:** Target < 8 GB per Codespace
- **Reliability:** phyloseq loads 100% of time
- **User feedback:** Can students find and use lessons?

## 🆘 If Things Break

### Image won't pull
- Check image is public: https://github.com/meekrob?tab=packages
- Verify URL in devcontainer.json matches

### Phyloseq fails
- Rebuild image locally, check build logs
- Test: `docker run --rm metagenomics-codespace:latest R -e "library(phyloseq)"`

### Lessons not visible in RStudio
- Check symlinks: `docker exec <container> ls -la /home/rstudio/`
- Verify setup.sh ran: Check Codespace logs

### Out of disk space
- Clean conda: `conda clean --all -y`
- Remove K-mer dirs: `rm -rf ~/dc_workshop/results/assembly*/K*/`

---

## 📞 Quick Reference

**Local testing:**
```bash
cd .devcontainer
./build-and-push.sh build
docker run --rm -d -p 8787:8787 -e DISABLE_AUTH=true \
  -v /Users/david/work/codespace-metagenomics-analysis:/workspaces/codespace-metagenomics-analysis \
  metagenomics-codespace:latest
# Open http://localhost:8787
```

**Rebuild and push:**
```bash
cd .devcontainer
./build-and-push.sh build-push  # Build + test + push
```

**Check image:**
```bash
docker images metagenomics-codespace
docker history metagenomics-codespace:latest
```

---

**Current Status:** ✅ Ready for deployment!
**Next Action:** Deploy to repo OR continue testing → your choice!
