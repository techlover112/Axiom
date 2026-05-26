# Dockerfile to prepare a build environment for Axiom
# Installs devkitPro/devkitARM and related 3DS tools requested by the project.
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Basic build tools
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    gnupg \
    lsb-release \
    build-essential \
    python3 \
    unzip \
    cmake \
    ninja-build \
    pkg-config \
    meson \
 && rm -rf /var/lib/apt/lists/*

# Install devkitpro pacman (dkp-pacman) and the devkitPro toolchain
# This script is provided by devkitPro and will install into /opt/devkitpro
RUN curl -fsSL https://devkitpro.org/devkitpro-pacman/install.sh | bash

ENV DEVKITPRO=/opt/devkitpro
ENV DEVKITARM=${DEVKITPRO}/devkitARM
ENV PATH=${DEVKITPRO}/tools/bin:${DEVKITARM}/bin:${PATH}

# Update devkitPro package database and install requested packages
# Packages: devkitARM, libctru (>=2.5.0), makerom, bannertool, flips, armips, 3gxtool
RUN ${DEVKITPRO}/tools/bin/dkp-pacman -Syu --noconfirm \
 && ${DEVKITPRO}/tools/bin/dkp-pacman -S --noconfirm \
    devkitARM \
    libctru \
    makerom \
    bannertool \
    flips \
    armips \
    3gxtool

# Clone CTRPluginFramework into the image so it's available for builds
RUN git clone --depth 1 https://github.com/CTSRD-CH/CTRPluginFramework /opt/CTRPluginFramework \
 && mkdir -p /opt/CTRPluginFramework/build \
 && cd /opt/CTRPluginFramework/build \
 && cmake .. || true

WORKDIR /work
CMD ["/bin/bash"]
