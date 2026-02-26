# .Rmd Conversion Guide

## What Was Done

All 10 lesson files have been converted from `.md` to `.Rmd`:
- ✅ Jekyll syntax removed (`{: .language-r}`, etc.)
- ✅ YAML frontmatter added
- ✅ Image links fixed (`{{ page.root }}` → `..`)
- ✅ Code blocks converted (~~~ → ```)
- ✅ Code kept as quoted blocks (not R chunks yet)

## Files Created

```
lessons/
├── 01-background-metadata.Rmd    ✅ Converted
├── 02-assessing-read-quality.Rmd ✅ Converted
├── 03-trimming-filtering.Rmd     ✅ Converted
├── 04-assembly.Rmd               ✅ Converted
├── 05-binning.Rmd                ✅ Converted
├── 06-taxonomic.Rmd              ✅ Converted
├── 07-phyloseq.Rmd               ✅ Converted (R lesson)
├── 08-Diversity-tackled-with-R.Rmd ✅ Converted (R lesson)
├── 09-abundance-analyses.Rmd     ✅ Converted (R lesson)
└── 10-OtherResources.Rmd         ✅ Converted
```

Original `.md` files are preserved (can delete later if you want).

## Next: Converting Code Blocks to R Chunks

### Current State (Quoted Blocks)

```
First, we tell R in which directory we are working.
```
> setwd("~/dc_workshop/taxonomy/")
```
```

### Option 1: Leave as Quoted (Read-Only)

**Good for:**
- Lessons 1-6 (command-line tools)
- Example code students copy-paste
- Teaching syntax without execution

**Students:**
- Read the lesson
- Copy code manually
- Paste into Console

### Option 2: Convert to R Chunks (Executable)

**Good for:**
- Lessons 7-9 (R analysis)
- Code that should run sequentially
- Interactive exploration

**Change to:**
```
First, we tell R in which directory we are working.
```{r}
setwd("~/dc_workshop/taxonomy/")
```
```

**Students can:**
- Run individual chunks (green arrow)
- Run all chunks (Knit button)
- See output inline

### Option 3: Hybrid Approach (Recommended)

**Lessons 1-6:** Keep as quoted blocks (bash commands)
```
```bash
fastqc *.fastq.gz
```
```

**Lessons 7-9:** Convert R code to chunks
```{r}
library(phyloseq)
setwd("~/dc_workshop/taxonomy/")
```

## Conversion Examples

### Bash Code (Keep Quoted)

**Before:**
```
$ cd ~/dc_workshop/data
$ fastqc *.fastq.gz
```

**After (.Rmd):**
````markdown
```bash
cd ~/dc_workshop/data
fastqc *.fastq.gz
```
````

### R Code (Convert to Chunk)

**Before:**
```
> library(phyloseq)
> merged_metagenomes <- import_biom("cuatroc.biom")
```

**After (.Rmd):**
````markdown
```{r load-data}
library(phyloseq)
merged_metagenomes <- import_biom("cuatroc.biom")
```
````

**Note:** Chunk names (e.g., `load-data`) are optional but helpful.

### Mixed Example (Lesson 07)

**Recommended structure for 07-phyloseq.Rmd:**

````markdown
---
title: "Exploring Taxonomy with R"
output: html_document
---

## Setup

```{r setup, message=FALSE, warning=FALSE}
library(phyloseq)
library(ggplot2)
setwd("~/dc_workshop/taxonomy/")
```

## Creating the phyloseq object

```{r import-biom}
merged_metagenomes <- import_biom("cuatroc.biom")
class(merged_metagenomes)
```

The object is of class `phyloseq`.

## Exploring taxonomic labels

```{r view-taxonomy}
View(merged_metagenomes@tax_table@.Data)
```

... and so on
````

## Testing Your .Rmd Files

### In RStudio

1. **Open file:** Files panel → `lessons/` → click `07-phyloseq.Rmd`
2. **Preview:** Click **"Preview"** button (top of editor)
   - Or press `Cmd+Shift+K` / `Ctrl+Shift+K`
3. **Run chunks:** Click green arrow on individual chunks
4. **Knit to HTML:** Click **"Knit"** button (renders full document)

### What to Check

- [ ] Images display correctly (`../fig/...` paths work)
- [ ] Code blocks render properly
- [ ] Links work (to other lessons, if any)
- [ ] R chunks execute without errors
- [ ] Output displays inline or in HTML

## Chunk Options Reference

### Common Options

````markdown
```{r chunk-name, eval=FALSE}
# Code shown but not executed
```

```{r include=FALSE}
# Code executed but not shown in output
```

```{r echo=FALSE}
# Output shown, code hidden
```

```{r message=FALSE, warning=FALSE}
# Suppress messages and warnings
```

```{r fig.width=8, fig.height=6}
# Control figure dimensions
```
````

### For Teaching

Most chunks should just be:
````markdown
```{r}
# Code here
```
````

Let students see everything by default.

## Recommended Conversion Strategy

### Phase 1: Quick Test (Do This First)

1. **Pick one R lesson:** `07-phyloseq.Rmd`
2. **Convert a few code blocks to chunks:**
   - Setup (library loads)
   - 2-3 analysis chunks
3. **Test in RStudio:**
   - Does it render?
   - Do chunks run?
   - Do images work?
4. **If good, continue...**

### Phase 2: Convert R Lessons (7-9)

Only convert the R analysis lessons to full R chunks:
- `07-phyloseq.Rmd` - Create phyloseq object, explore data
- `08-Diversity-tackled-with-R.Rmd` - Diversity metrics
- `09-abundance-analyses.Rmd` - Abundance plots

**Time estimate:** 30-60 min per lesson

### Phase 3: Leave Bash Lessons (1-6)

Keep command-line lessons as quoted bash blocks:
- `01-background-metadata.Rmd` - No code
- `02-assessing-read-quality.Rmd` - bash commands
- `03-trimming-filtering.Rmd` - bash commands
- `04-assembly.Rmd` - bash commands
- `05-binning.Rmd` - bash commands
- `06-taxonomic.Rmd` - bash + kraken-biom

Students copy-paste into **Terminal** tab, not Console.

## Re-running the Converter

If you need to reconvert after editing original `.md` files:

```bash
# Convert all
python3 .devcontainer/convert-md-to-rmd.py

# Convert single file
python3 .devcontainer/convert-md-to-rmd.py lessons/07-phyloseq.md

# Convert to different output
python3 .devcontainer/convert-md-to-rmd.py lessons/07-phyloseq.md -o lessons/test.Rmd
```

## Updating WELCOME.md

After converting to R chunks, update the welcome:

```markdown
## 📚 Lessons

All lessons are in `.Rmd` format (R Markdown):

**Open in RStudio:**
1. Files panel → `lessons/`
2. Click any `.Rmd` file
3. File opens in editor pane

**For command-line lessons (1-6):**
- Read in RStudio
- Copy bash commands
- Paste into **Terminal** tab

**For R analysis lessons (7-9):**
- Read in RStudio
- Run R chunks with green arrows
- Or copy-paste into Console
- Or click **Knit** to render full HTML

All lessons open and render beautifully in RStudio!
```

## Final Checklist

Before committing:

- [ ] Test at least one .Rmd file renders in RStudio
- [ ] Verify images work (`../fig/` paths)
- [ ] Convert R lessons (7-9) to chunks (optional but recommended)
- [ ] Update WELCOME.md to reference .Rmd files
- [ ] Update symlinks in setup.sh (still point to lessons/)
- [ ] Decide: keep or delete original .md files?

## Questions?

**Q: Should I delete the .md files?**
A: Keep them for now. You can `.gitignore` them later or delete after confirming .Rmd works.

**Q: Do I need to convert bash code to chunks?**
A: No! Bash blocks should stay quoted. Only R code benefits from chunks.

**Q: What if a lesson has both bash and R?**
A: Use both! Bash in quoted blocks, R in chunks.

**Q: How do I test without data files?**
A: Use `eval=FALSE` on chunks that need data, or add sample data to test rendering.

---

**You're ready!** Start with `07-phyloseq.Rmd`, convert some chunks, test in RStudio, and iterate from there.
