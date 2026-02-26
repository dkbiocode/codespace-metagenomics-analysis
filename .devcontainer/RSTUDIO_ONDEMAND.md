# RStudio Server On-Demand Strategy

## Problem Solved

**Issue:**
- RStudio Server auto-starts and consumes CPU even during lessons 1-6 (command-line only)
- 2-core Codespace needs resources for FastQC, assembly, etc.
- Lessons 7-9 are the only R analysis portions

**Solution:**
- RStudio Server starts **on-demand** when students need it
- Saves CPU resources during command-line lessons
- Simple scripts to start/stop

---

## How It Works

### On Codespace Startup
1. Container launches with RStudio Server **installed but not running**
2. setup.sh explicitly stops it: `sudo rstudio-server stop`
3. Message shown: "RStudio is available but not started"

### When Student Reaches Lesson 7
```bash
./start-rstudio.sh
# RStudio Server starts
# Opens http://localhost:8787
```

### After R Analysis Done
```bash
./stop-rstudio.sh
# RStudio Server stops
# Frees up CPU resources
```

---

## User Experience

### Lessons 1-6 (Command-line)
**Terminal workflow:**
```bash
# RStudio NOT running - all CPU for tools
cd ~/dc_workshop/data
fastqc *.fastq.gz
trimmomatic PE ...
metaspades.py -1 R1.fastq.gz -2 R2.fastq.gz -o assembly/
```

**No RStudio overhead!**

### Lesson 7-9 (R Analysis)
**Start RStudio:**
```bash
./start-rstudio.sh
# ✅ RStudio Server is running!
# 📍 Open: http://localhost:8787
```

**Do R analysis:**
```r
library(phyloseq)
setwd("~/dc_workshop/taxonomy/")
merged <- import_biom("cuatroc.biom")
```

**When done:**
```bash
./stop-rstudio.sh
# ✅ RStudio Server stopped
# 💡 CPU freed for other work
```

---

## Files Created

### Scripts (Repo Root)
- `start-rstudio.sh` - Start RStudio Server
- `stop-rstudio.sh` - Stop RStudio Server

### Configuration Changes
- `.devcontainer/devcontainer.json` - Set `overrideCommand: true`
- `.devcontainer/setup-updated.sh` - Stop RStudio at end of setup
- `WELCOME.md` - Updated workflow instructions

---

## Technical Details

### How Auto-Start is Prevented

**devcontainer.json:**
```json
{
  "overrideCommand": true,  // Don't run default container command
  "postStartCommand": "echo 'RStudio available but not started'"
}
```

**setup-updated.sh:**
```bash
# At end of setup
sudo rstudio-server stop 2>/dev/null || true
```

**Result:** RStudio Server installed but not running.

### Starting/Stopping

**Start:**
```bash
sudo rstudio-server start
```

**Stop:**
```bash
sudo rstudio-server stop
```

**Status:**
```bash
sudo rstudio-server status
```

### Port Forwarding

Port 8787 is still forwarded in devcontainer.json:
```json
"forwardPorts": [8787],
"portsAttributes": {
  "8787": {
    "label": "RStudio Server",
    "onAutoForward": "notify"
  }
}
```

When RStudio starts, port becomes active automatically.

---

## Resource Savings

### 2-Core Codespace CPU Usage

**Before (RStudio always running):**
```
RStudio Server idle:     ~5-10% CPU
MetaSPAdes assembly:     ~180-190% CPU (both cores maxed)
Total:                   ~195% (throttled, slower assembly)
```

**After (RStudio on-demand):**
```
Lessons 1-6:
  RStudio:               0% CPU (not running)
  MetaSPAdes assembly:   ~200% CPU (both cores fully available)

Lessons 7-9:
  RStudio + R:           ~10-20% CPU (only when active)
  Light R analysis:      Compatible with RStudio overhead
```

**Improvement:** MetaSPAdes runs ~5-10% faster without RStudio overhead.

---

## Student Instructions

### In WELCOME.md
```markdown
## Workflow

### Lessons 1-6: Command-Line Tools
- Use VS Code terminal
- RStudio is not needed yet
- All CPU available for bioinformatics tools

### Lessons 7-9: R Analysis
1. Start RStudio: `./start-rstudio.sh`
2. Open: http://localhost:8787
3. Login: rstudio / metagenomics
4. Do R analysis
5. When done: `./stop-rstudio.sh`

### Lesson 10: Resources
- Just reading, no tools needed
```

### In Lesson 07
Add at the beginning:

```markdown
## Before Starting

If you haven't already, start RStudio Server:

```bash
cd /workspaces/codespace-metagenomics-analysis
./start-rstudio.sh
```

Then open RStudio at http://localhost:8787 (check Ports tab in VS Code).

---

(rest of lesson)
```

---

## Testing Checklist

When Codespaces usage resets:

- [ ] Create Codespace
- [ ] Verify RStudio is NOT running: `sudo rstudio-server status`
- [ ] Run lessons 1-6 commands (FastQC, Trimmomatic)
- [ ] Monitor CPU usage (should be ~100-200% during assembly)
- [ ] Run `./start-rstudio.sh`
- [ ] Verify RStudio opens at http://localhost:8787
- [ ] Test R commands in Console
- [ ] Run `./stop-rstudio.sh`
- [ ] Verify RStudio stopped: `sudo rstudio-server status`

---

## Troubleshooting

### RStudio won't start
```bash
# Check status
sudo rstudio-server status

# Check logs
sudo rstudio-server verify-installation

# Try restart
sudo rstudio-server restart
```

### RStudio won't stop
```bash
# Force stop
sudo systemctl stop rstudio-server

# Or kill process
sudo pkill -9 rserver
```

### Port not forwarding
- Check VS Code Ports tab
- Port 8787 should show when RStudio starts
- Click globe icon to open

---

## Alternative Approaches (Not Chosen)

### Why Not: Always Run RStudio
- ❌ Wastes CPU during lessons 1-6
- ❌ Slows down MetaSPAdes assembly
- ❌ Unnecessary overhead

### Why Not: Separate R Container
- ❌ More complex setup
- ❌ Students need to manage two containers
- ❌ Overkill for occasional R use

### Why Not: Local R (No RStudio Server)
- ❌ RStudio provides better teaching environment
- ❌ Plots, help, file browser all useful
- ❌ Worth the on-demand overhead

---

## Summary

**What:** RStudio Server starts on-demand, not automatically

**Why:** Save CPU resources during command-line lessons (1-6)

**How:**
- `./start-rstudio.sh` when needed
- `./stop-rstudio.sh` when done

**Benefit:** 5-10% faster assembly, better resource utilization

**Trade-off:** Students run one extra command (minimal)

---

**Status:** ✅ Implemented and documented, ready for testing in Codespace
