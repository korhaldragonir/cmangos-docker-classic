# Download base image ubuntu
FROM ubuntu:20.04 AS builder

# Fetch build arguments
ARG CORE_COMMIT_HASH=HEAD \
    DB_COMMIT_HASH=HEAD

# Set Timezone
ENV TZ=Europe/Amsterdam \
    ENV_CORE_COMMIT_HASH=$CORE_COMMIT_HASH \
    ENV_DB_COMMIT_HASH=$DB_COMMIT_HASH \
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

# Prepare Sources
RUN mkdir -p /opt/src && \
    git clone https://github.com/cmangos/mangos-classic.git /opt/src/cmangos && \
    echo "Core Version: ${ENV_CORE_COMMIT_HASH}" && \
    if [ "$ENV_CORE_COMMIT_HASH" != "HEAD" ]; then echo "Switching to Commit: ${ENV_CORE_COMMIT_HASH}\n"; cd /opt/src/cmangos; git checkout ${ENV_CORE_COMMIT_HASH}; fi

# Build Software
RUN mkdir -p /opt/cmangos/logs /opt/src/cmangos/build && \
    cd /opt/src/cmangos/build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/opt/cmangos -DBUILD_GAME_SERVER=OFF && \
    make -j 4 && make install

# Prepare Config Files
RUN cd /opt/cmangos/etc && mv -v realmd.conf.dist realmd.conf
RUN cd /opt/cmangos/etc && \
    sed -i 's/127.0.0.1;3306;mangos/database;3306;mangos/g' realmd.conf && \
    sed -i 's/MaxPingTime \= 30/MaxPingTime \= 5/g' realmd.conf

# Extract runtime files and cleanup
RUN rm -rfv /opt/src

# Download base image ubuntu
FROM ubuntu:20.04

# Install dependencies for running CMaNGOSd.
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -q -y \
    binutils \
    libboost-dev \
    libboost-filesystem1.71.0 \
    libboost-program-options1.71.0 \
    libboost-regex1.71.0 \
    libboost-system1.71.0 \
    libboost-thread1.71.0 \
    libc6 \
    libcurl4 \
    libmysql++3v5 \
    libpthread-stubs0-dev \
    libssl1.1 \
    libtool \
    openssl \
    pkg-config \
    tzdata \
    unrar-free \
    unzip \
    zlibc && \
    rm -rf /var/lib/apt/lists/*

# Copy over data
COPY --from=builder /opt/cmangos /opt/cmangos

# Fetch build arguments
ARG CORE_COMMIT_HASH=HEAD \
    DB_COMMIT_HASH=HEAD

# Set Timezone
ENV TZ=Europe/Amsterdam \
    ENV_CORE_COMMIT_HASH=$CORE_COMMIT_HASH \
    ENV_DB_COMMIT_HASH=$DB_COMMIT_HASH

# Volume configuration
VOLUME ["/opt/cmangos/etc"]

# Copy over init scripts and make them executable
COPY 00_init.sh /00_init.sh
COPY wait-for-it.sh /wait-for-it.sh
RUN chmod +x /00_init.sh && chmod +x /wait-for-it.sh

# Prepare tini init
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]
CMD ["/00_init.sh"]

# Expose ports
EXPOSE 3724