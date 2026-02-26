FROM rocker/rstudio:4.3

# Configure passwordless sudo for rstudio user (needed for setup script)
RUN echo "rstudio ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/rstudio \
    && chmod 0440 /etc/sudoers.d/rstudio

# Install sudo if not already present
RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*

# Note: R packages are installed in setup.sh using pre-built binaries
# This keeps the Docker image build fast and allows for easier updates
