# Dockerfile to prepare a build environment for Axiom
# Installs devkitPro/devkitARM and related 3DS tools requested by the project.
FROM devkitpro/devkitarm:latest

ENV DEBIAN_FRONTEND=noninteractive

# Minimal extra packages useful for building and tooling
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    git \
    curl \
    build-essential \
    cmake \
    ninja-build \
    python3 \
    unzip \
    pkg-config \
    meson \
 && rm -rf /var/lib/apt/lists/*

ENV DEVKITPRO=/opt/devkitpro
ENV DEVKITARM=${DEVKITPRO}/devkitARM
ENV PATH=${DEVKITPRO}/tools/bin:${DEVKITARM}/bin:${PATH}

# Update dkp-pacman and install required devkitPro packages
# See: https://devkitpro.org/wiki/devkitPro_pacman
RUN ${DEVKITPRO}/tools/bin/dkp-pacman -Syu --noconfirm \
 && ${DEVKITPRO}/tools/bin/dkp-pacman -S --noconfirm \
    devkitARM \
    libctru \
    makerom \
    bannertool \
    flips \
    armips \
    3gxtool || true

# Clone CTRPluginFramework into the image so it's available for builds
RUN for i in {1..3}; do git clone --depth 1 https://github.com/CTSRD-CH/CTRPluginFramework /opt/CTRPluginFramework && break || sleep 10; done \
 && mkdir -p /opt/CTRPluginFramework/build

WORKDIR /app
CMD make -f Makefile -j$(nproc)
