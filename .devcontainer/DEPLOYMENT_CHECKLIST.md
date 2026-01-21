# Deployment Checklist for GitHub Codespaces

## Pre-Deployment Checks

### 1. Files Present
- [x] `.devcontainer/devcontainer.json`
- [x] `.devcontainer/setup.sh` (executable)
- [x] `.devcontainer/FREE_TIER_STRATEGY.md` (documentation)
- [ ] `README.md` in repository root (should be created/updated)
- [ ] `.gitignore` (to exclude large data files)

### 2. Repository Setup
```bash
cd /Users/david/work/codespace-metagenomics-analysis

# Initialize git if not already
git init

# Add all files
git add .

# Commit
git commit -m "Add devcontainer configuration for RStudio Server"

# Create GitHub repository and push
# (Follow GitHub instructions to create repo)
git remote add origin <your-repo-url>
git branch -M main
git push -u origin main
```

### 3. GitHub Repository Settings

After pushing to GitHub:

1. **Enable Codespaces**:
   - Repository Settings → Codespaces → Allow Codespaces

2. **Set Default Machine Type** (optional):
   - Repository Settings → Codespaces → Set default machine type to "2-core"

3. **Add Repository Secrets** (if needed):
   - None required for basic setup

## Testing the Codespace

### Method 1: Via GitHub Web Interface

1. Go to your repository on GitHub
2. Click the green "Code" button
3. Select "Codespaces" tab
4. Click "Create codespace on main"

### Method 2: Via GitHub CLI

```bash
# Install GitHub CLI if not already
# brew install gh  # macOS

# Login
gh auth login

# Create codespace
gh codespace create --repo <username>/<repo-name>

# Or create and connect in browser
gh codespace create --repo <username>/<repo-name> --web
```

### Method 3: Via VS Code

1. Install "GitHub Codespaces" extension in VS Code
2. Command Palette (Cmd+Shift+P) → "Codespaces: Create New Codespace"
3. Select your repository

## What to Expect During First Build

### Timeline:
```
1. Pulling rocker/rstudio:4.3 image        (2-3 minutes)
2. Installing conda feature                (2-3 minutes)
3. Running setup.sh:
   - Installing system dependencies        (2-3 minutes)
   - Creating conda environment            (8-12 minutes)
   - Installing R packages                 (5-8 minutes)
   - Creating directories                  (< 1 minute)
   - Downloading adapters                  (< 1 minute)
------------------------------------------------------
Total expected time:                       (20-30 minutes)
```

### Build Log Indicators of Success:
```
✓ "Installing system dependencies..."
✓ "Creating metagenomics conda environment (this may take 10-15 minutes)..."
✓ "Activating metagenomics environment and installing R packages..."
✓ "Creating workspace directories..."
✓ "=== Setup Complete! ==="
```

## Post-Build Validation

### 1. Check RStudio Server Access

**Expected**:
- VS Code shows "Ports" tab with port 8787 forwarded
- Click on port 8787 to open RStudio in browser
- Should see RStudio interface (no login required due to DISABLE_AUTH=true)

**If port not forwarded**:
```bash
# Manually forward port in VS Code terminal
# Or check Ports tab and click "Forward a Port"
```

### 2. Test Conda Environment

In RStudio Terminal tab:
```bash
# Should already be activated, but test:
conda activate metagenomics

# Check installed tools
fastqc --version          # Should show v0.12.1 or similar
trimmomatic -version      # Should show 0.39
metaspades.py --version   # Should show SPAdes v3.15.5
kraken2 --version         # Should show 2.1.3
```

### 3. Test R Packages

In RStudio Console (R prompt `>`):
```r
# Check R version
R.version.string

# Check packages
library(phyloseq)
library(ggplot2)
library(RColorBrewer)
library(patchwork)

# Should load without errors
```

### 4. Check Directory Structure

In RStudio Terminal:
```bash
ls -la ~/dc_workshop/
# Should show: data/ results/ taxonomy/ mags/ docs/

ls -la ~/dc_workshop/data/
# Should show: untrimmed_fastq/ trimmed_fastq/

ls -la ~/dc_workshop/data/untrimmed_fastq/
# Should show: download_data.sh TruSeq3-PE.fa
```

### 5. Test a Simple Command

In RStudio Terminal:
```bash
cd ~/dc_workshop/data/untrimmed_fastq

# Create a tiny test file
echo "@test" > test.fastq
echo "ACTG" >> test.fastq
echo "+" >> test.fastq
echo "IIII" >> test.fastq

# Run FastQC on it
fastqc test.fastq

# Should create test_fastqc.html and test_fastqc.zip
ls -lh
```

## Known Issues and Workarounds

### Issue 1: Conda Environment Not Activated
**Symptom**: Commands like `fastqc` not found

**Fix**:
```bash
conda init bash
source ~/.bashrc
conda activate metagenomics
```

### Issue 2: RStudio Server Not Starting
**Symptom**: Port 8787 shows "Connection refused"

**Fix**:
```bash
# Check if RStudio is running
ps aux | grep rstudio

# If not running, start manually
sudo rstudio-server start

# Check status
sudo rstudio-server status
```

### Issue 3: R Packages Not Installed
**Symptom**: `library(phyloseq)` gives error

**Fix**:
```r
# In R console
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("phyloseq")
install.packages(c("ggplot2", "RColorBrewer", "patchwork", "vegan"))
```

### Issue 4: Out of Storage Space
**Symptom**: "No space left on device"

**Check**:
```bash
df -h
# Look at /dev/vda1 or similar (should be <32GB used)

# Clean up if needed
conda clean --all -y
rm -rf ~/.cache/*
```

### Issue 5: Setup Script Failed
**Symptom**: Build completes but tools missing

**Fix**: Re-run setup manually:
```bash
cd /workspaces/<repo-name>
bash .devcontainer/setup.sh
```

## Resource Monitoring

### During Setup:
```bash
# Memory usage
free -h

# CPU usage
htop  # or: top

# Disk usage
df -h
du -sh ~/dc_workshop
du -sh ~/micromamba  # or: ~/conda
```

### Expected Resource Usage After Setup:
```
Memory: ~2-3 GB used of 8 GB
Disk: ~8-10 GB used of 32 GB
CPU: Low when idle
```

## Troubleshooting Commands

```bash
# Check what's using space
du -sh /* 2>/dev/null | sort -h

# Check conda environments
conda env list

# Check running processes
ps aux --sort=-%mem | head -20

# Check network connectivity
curl -I https://github.com

# Check RStudio logs
sudo tail -f /var/log/rstudio-server/rserver.log

# Rebuild devcontainer from scratch
# (From VS Code Command Palette)
# "Codespaces: Rebuild Container"
```

## Success Criteria

Before considering deployment successful, verify:

- [ ] Codespace builds without errors
- [ ] RStudio Server accessible in browser
- [ ] Can switch between Terminal and Console in RStudio
- [ ] Conda environment activates automatically
- [ ] FastQC runs successfully
- [ ] R packages load without errors
- [ ] Directory structure matches lessons
- [ ] Total setup time < 30 minutes
- [ ] Storage usage < 12 GB
- [ ] No error messages in build log

## Next Steps After Successful Deployment

1. **Add sample data**:
   - Upload JC1A FASTQ files to repository or provide download script
   - Or create instructions for students to download from SRA

2. **Add pre-computed results**:
   - Upload pre-computed assembly, Kraken2, binning results
   - Add to `results/precomputed/` directory

3. **Update lessons**:
   - Add callout boxes about free tier optimization
   - Reference pre-computed results where appropriate

4. **Create student guide**:
   - Write step-by-step Codespace setup instructions
   - Include screenshots of key steps
   - Add troubleshooting section

5. **Test with a student**:
   - Have someone unfamiliar test the setup
   - Document any confusion or errors
   - Iterate on documentation

## Rollback Plan

If deployment fails or has critical issues:

1. **Revert devcontainer**:
   ```bash
   git revert <commit-hash>
   git push
   ```

2. **Delete and recreate Codespace**:
   - Stop current Codespace
   - Delete it
   - Create new one from reverted commit

3. **Emergency fixes**:
   - Can edit `.devcontainer/setup.sh` in active Codespace
   - Test fixes manually
   - Commit fixes when working
   - Rebuild container to test clean build

## Contact Information

If you encounter issues:
- Check build logs in VS Code Output panel
- Review GitHub Codespaces documentation: https://docs.github.com/en/codespaces
- Check Rocker documentation: https://rocker-project.org/
- Check this repository's Issues tab

## Final Pre-Push Checklist

Before pushing to GitHub:

- [ ] `.devcontainer/devcontainer.json` syntax is valid JSON
- [ ] `.devcontainer/setup.sh` is executable (`chmod +x`)
- [ ] No hardcoded credentials or secrets in files
- [ ] README.md updated with Codespace instructions
- [ ] .gitignore includes patterns for data files if needed
- [ ] Repository is public or you have Codespaces enabled for private repos
- [ ] You have sufficient GitHub Codespaces quota (60 hours free tier)

**You are now ready to push and test!**
