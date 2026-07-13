#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Configuration
REGISTRY="ghcr.io"
IMAGE_OWNER="k-atusa"
IMAGE_NAME="wire"
FULL_IMAGE_NAME="${REGISTRY}/${IMAGE_OWNER}/${IMAGE_NAME}"

# Print banner
echo "=============================================="
echo "  Next.js Docker Build & Push to GHCR"
echo "  Target: ${FULL_IMAGE_NAME}"
echo "=============================================="

# Check if docker is installed
if ! command -v docker &> /dev/null; then
    echo "Error: docker is not installed. Please install docker first."
    exit 1
fi

# Check authentication status
echo "Checking GHCR connection..."
if ! docker system info > /dev/null 2>&1; then
    echo "Error: Docker daemon is not running. Please start Docker first."
    exit 1
fi

# Prompt for GitHub PAT if not already logged in
read -p "Do you need to log in to GHCR? (y/N): " LOGIN_REQUIRED
if [[ "$LOGIN_REQUIRED" =~ ^[Yy]$ ]]; then
    echo "Please provide your GitHub username and Personal Access Token (PAT) with package write permissions."
    read -p "GitHub Username: " GH_USER
    read -sp "GitHub PAT (Token): " GH_PAT
    echo ""
    echo "Logging in to ${REGISTRY}..."
    echo "${GH_PAT}" | docker login ${REGISTRY} -u "${GH_USER}" --password-stdin
fi

# Generate Tags
GIT_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
TIMESTAMP=$(date +%Y%m%d%H%M%S)
TAG_COMMIT="${FULL_IMAGE_NAME}:sha-${GIT_COMMIT}"
TAG_TIMESTAMP="${FULL_IMAGE_NAME}:t-${TIMESTAMP}"
TAG_LATEST="${FULL_IMAGE_NAME}:latest"

read -p "Do you want to build for multi-platform (linux/amd64, linux/arm64)? (y/N): " MULTI_PLATFORM

if [[ "$MULTI_PLATFORM" =~ ^[Yy]$ ]]; then
    # Multi-platform requires pushing directly since local daemon doesn't support multi-arch loading
    echo "Note: Multi-platform builds (amd64/arm64) will be pushed directly to GHCR."
    read -p "Are you ready to build and push to GHCR now? (y/N): " CONFIRM_PUSH
    if [[ "$CONFIRM_PUSH" =~ ^[Yy]$ ]]; then
        echo "Creating/using buildx builder..."
        docker buildx create --use --name multi-platform-builder 2>/dev/null || docker buildx use multi-platform-builder
        echo "Building and pushing multi-platform Docker images..."
        docker buildx build \
          --platform linux/amd64,linux/arm64 \
          --build-arg NEXT_TELEMETRY_DISABLED=1 \
          -t "${TAG_LATEST}" \
          -t "${TAG_COMMIT}" \
          -t "${TAG_TIMESTAMP}" \
          --push \
          .
        echo "=============================================="
        echo "  Multi-platform build and push completed successfully!"
        echo "  Your image is available at:"
        echo "  https://github.com/${IMAGE_OWNER}/${IMAGE_NAME}/pkgs/container/${IMAGE_NAME}"
        echo "=============================================="
    else
        echo "Cancelled."
    fi
else
    # Standard single platform build
    echo "Building Docker image for local platform..."
    docker build \
      --build-arg NEXT_TELEMETRY_DISABLED=1 \
      -t "${TAG_LATEST}" \
      -t "${TAG_COMMIT}" \
      -t "${TAG_TIMESTAMP}" \
      .

    echo "Build successful! Tags generated:"
    echo "  - ${TAG_LATEST}"
    echo "  - ${TAG_COMMIT}"
    echo "  - ${TAG_TIMESTAMP}"

    read -p "Do you want to push these images to GHCR now? (y/N): " CONFIRM_PUSH
    if [[ "$CONFIRM_PUSH" =~ ^[Yy]$ ]]; then
        echo "Pushing images..."
        docker push "${TAG_LATEST}"
        docker push "${TAG_COMMIT}"
        docker push "${TAG_TIMESTAMP}"
        echo "=============================================="
        echo "  Push completed successfully!"
        echo "  Your image is available at:"
        echo "  https://github.com/${IMAGE_OWNER}/${IMAGE_NAME}/pkgs/container/${IMAGE_NAME}"
        echo "=============================================="
    else
        echo "Push cancelled. You can push them later using:"
        echo "  docker push ${TAG_LATEST}"
    fi
fi
