#!/bin/bash
set -e

# Build and Push Script for Metagenomics Codespace Image
# Usage:
#   ./build-and-push.sh build        # Build locally and test
#   ./build-and-push.sh push         # Push to GitHub Container Registry
#   ./build-and-push.sh build-push   # Build and push in one step

# Configuration
IMAGE_NAME="metagenomics-codespace"
GITHUB_USERNAME="${GITHUB_USERNAME:-meekrob}"  # Your GitHub username
IMAGE_TAG="${IMAGE_TAG:-latest}"
FULL_IMAGE_NAME="ghcr.io/${GITHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"

echo "==============================================="
echo "Metagenomics Codespace Image Builder"
echo "==============================================="
echo "Image: ${FULL_IMAGE_NAME}"
echo ""

# Function to build the image
build_image() {
    echo "📦 Building Docker image locally..."
    echo "This will take 10-15 minutes (phyloseq installation is slow)"
    echo ""

    # Build from the .devcontainer directory
    docker build \
        --platform linux/amd64 \
        -f Dockerfile.prebuilt \
        -t "${IMAGE_NAME}:${IMAGE_TAG}" \
        -t "${FULL_IMAGE_NAME}" \
        ..

    echo ""
    echo "✅ Image built successfully!"
    echo ""

    # Show image size
    docker images "${IMAGE_NAME}:${IMAGE_TAG}" --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
}

# Function to test the image
test_image() {
    echo ""
    echo "🧪 Testing image..."
    echo "Verifying phyloseq loads correctly..."

    docker run --rm "${IMAGE_NAME}:${IMAGE_TAG}" R -e "library(phyloseq); cat('✅ phyloseq works!\n')"

    echo ""
    echo "✅ Image test passed!"
}

# Function to push to GitHub Container Registry
push_image() {
    echo ""
    echo "🚀 Pushing to GitHub Container Registry..."
    echo ""
    echo "Make sure you're logged in to ghcr.io:"
    echo "  docker login ghcr.io -u YOUR_USERNAME"
    echo ""
    read -p "Press Enter to continue or Ctrl+C to cancel..."

    docker push "${FULL_IMAGE_NAME}"

    echo ""
    echo "✅ Image pushed successfully!"
    echo ""
    echo "📝 Next steps:"
    echo "1. Update .devcontainer/devcontainer.json to use: ${FULL_IMAGE_NAME}"
    echo "2. Make image public in GitHub Packages settings (if needed)"
    echo "3. Test in a Codespace!"
}

# Main command handler
case "${1:-}" in
    build)
        build_image
        test_image
        echo ""
        echo "💡 To push to GitHub, run: $0 push"
        ;;
    test)
        test_image
        ;;
    push)
        push_image
        ;;
    build-push)
        build_image
        test_image
        push_image
        ;;
    *)
        echo "Usage: $0 {build|test|push|build-push}"
        echo ""
        echo "Commands:"
        echo "  build       - Build image locally and test"
        echo "  test        - Test existing local image"
        echo "  push        - Push local image to GitHub Container Registry"
        echo "  build-push  - Build, test, and push in one command"
        echo ""
        echo "Environment variables:"
        echo "  GITHUB_USERNAME - Your GitHub username (default: YOUR_USERNAME)"
        echo "  IMAGE_TAG       - Image tag (default: latest)"
        echo ""
        echo "Example:"
        echo "  GITHUB_USERNAME=yourusername $0 build-push"
        exit 1
        ;;
esac
