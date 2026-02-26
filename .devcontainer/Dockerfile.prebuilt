# Pre-built Dockerfile for Metagenomics Analysis Codespace
# This embeds the working phyloseq installation that was troubleshooted
# Build once locally, push to GHCR, deploy instantly to Codespaces

FROM rocker/rstudio:4.3

# =============================================================================
# System Dependencies
# =============================================================================

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget curl gzip bzip2 unzip git screen less nano \
    default-jre perl python3-pip \
    build-essential \
    libz-dev libbz2-dev liblzma-dev libncurses5-dev \
    libglpk40 libglpk-dev \
    libhdf5-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libgmp-dev \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Configure passwordless sudo
RUN echo "rstudio ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/rstudio \
    && chmod 0440 /etc/sudoers.d/rstudio

# =============================================================================
# R Packages - Using Your Working Installation Method
# =============================================================================

# Copy your pre-built binaries into the image
COPY binaries/*.tar.gz /tmp/binaries/

# Install CRAN dependencies first (same as your setup.sh)
RUN R -e "options(repos = c(CRAN = 'https://p3m.dev/cran/__linux__/jammy/latest')); \
    install.packages(c('jsonlite', 'cpp11', 'labeling', 'R6', 'viridisLite', \
    'cli', 'gtable', 'isoband', 'lifecycle', 'rlang', 'S7', 'scales', 'vctrs', \
    'withr', 'farver', 'permute', 'glue', 'magrittr', 'stringi', 'digest', \
    'plyr', 'Rcpp', 'iterators', 'foreach', 'bitops', 'RCurl', 'ggplot2', \
    'RColorBrewer', 'patchwork', 'vegan', 'stringr', 'crayon', 'lattice'))"

# Install RStudio markdown rendering dependencies
# These are needed for previewing .md files in RStudio
RUN R -e "options(repos = c(CRAN = 'https://p3m.dev/cran/__linux__/jammy/latest')); \
    install.packages(c('base64enc', 'evaluate', 'highr', 'htmltools', 'knitr', \
    'mime', 'rmarkdown', 'xfun', 'yaml', 'bslib', 'fontawesome', 'jquerylib', \
    'tinytex', 'fs', 'rappdirs', 'cachem', 'memoise', 'sass'))"

# Install pre-built binaries (your proven method)
RUN for tgz in /tmp/binaries/*.tar.gz; do R CMD INSTALL "$tgz"; done

# Verify phyloseq works
RUN R -e "library(phyloseq); cat('\n=== phyloseq loaded successfully! ===\n')"

# Clean up
RUN rm -rf /tmp/binaries /tmp/downloaded_packages/ /tmp/*.rds

# =============================================================================
# Image Metadata
# =============================================================================

LABEL org.opencontainers.image.description="Metagenomics Analysis with RStudio + phyloseq"
LABEL org.opencontainers.image.source="https://github.com/meekrob/codespace-metagenomics-analysis"

WORKDIR /home/rstudio
CMD ["/init"]
