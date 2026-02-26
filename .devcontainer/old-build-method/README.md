# Old Build Method (Archived)

This directory contains the original build configuration that installed R packages from binaries during Codespace creation.

## What Changed

**Old method (these files):**
- `Dockerfile` - Minimal base image
- `setup.sh` - Installed R packages from binaries (10-15 min)
- `devcontainer.json` - Ran setup.sh on every Codespace creation

**New method (active):**
- Pre-built container image: `ghcr.io/meekrob/metagenomics-codespace:latest`
- R packages baked into the image
- Faster startup (~11-12 min vs 25+ min)
- Lower disk usage (~6-7.5 GB vs 8-10 GB per Codespace)

## Why Keep These Files?

- Reference for how phyloseq was successfully installed
- Troubleshooting if the pre-built image needs to be rebuilt
- Understanding what binaries were needed

## Restoring Old Method

If you ever need to go back:

```bash
cp old-build-method/Dockerfile ../Dockerfile
cp old-build-method/setup.sh ../setup.sh
cp old-build-method/devcontainer.json ../devcontainer.json
```

Then update `devcontainer.json` to use `"build": {"dockerfile": "Dockerfile"}` instead of `"image"`.
