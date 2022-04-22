# Download base image ubuntu
FROM ubuntu:20.04

# Set Timezone
ENV TZ=Europe/Amsterdam \
    CMAKE_VERSION=3.23.1

# Update Ubuntu Software repository
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -q -y \
      autoconf \
      automake \
      binutils \
      build-essential \
      ca-certificates \
      cmake \
      cpp \
      g++ \
      gcc \
      git-core \
      libboost-dev \
      libboost-filesystem-dev \
      libboost-program-options-dev \
      libboost-regex-dev \
      libboost-system-dev \
      libboost-thread-dev \
      libc6 \
      libcurl4-openssl-dev \
      libmysql++-dev \
      libpthread-stubs0-dev \
      libssl-dev \
      libtool \
      make \
      openssl \
      patch \
      pkg-config \
      unrar-free \
      unzip \
      wget \
      zlibc && \
    rm -rf /var/lib/apt/lists/*

# Prepare new cmake
RUN cd /tmp && wget --no-check-certificate https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz && \
    tar -xvzf cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz && \
    mv /tmp/cmake-${CMAKE_VERSION}-linux-x86_64 /opt/cmake && \
    ln -s /opt/cmake/bin/* /usr/local/bin/ && \
    rm -f /tmp/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz

COPY build_script.sh /build.sh
RUN chmod 0755 /build.sh