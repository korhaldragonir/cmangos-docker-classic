# Download base image ubuntu
FROM ubuntu:18.04 AS builder

# Fetch build arguments
ARG CORE_COMMIT_HASH=HEAD \
    DB_COMMIT_HASH=HEAD

# Set Timezone
ENV TZ=Europe/Amsterdam \
    ENV_CORE_COMMIT_HASH=$CORE_COMMIT_HASH \
    ENV_DB_COMMIT_HASH=$DB_COMMIT_HASH

# Update Ubuntu Software repository
RUN DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -q -y git-core build-essential binutils gcc g++ cpp automake autoconf make libmysql++-dev libtool libssl-dev libcurl4-openssl-dev unrar-free unzip patch zlibc libc6 openssl pkg-config cmake libboost-dev libboost-filesystem-dev libboost-program-options-dev libboost-system-dev libboost-thread-dev libboost-dev libboost-regex-dev libpthread-stubs0-dev wget && \
    rm -rf /var/lib/apt/lists/*

# Prepare new cmake
RUN cd /tmp && wget --no-check-certificate https://github.com/Kitware/CMake/releases/download/v3.16.2/cmake-3.16.2-Linux-x86_64.tar.gz && \
    tar -xvzf cmake-3.16.2-Linux-x86_64.tar.gz && \
    mv /tmp/cmake-3.16.2-Linux-x86_64 /opt/cmake && \
    ln -s /opt/cmake/bin/* /usr/local/bin/ && \
    rm -f /tmp/cmake-3.16.2-Linux-x86_64.tar.gz

# Prepare Sources
RUN mkdir -p /opt/src && \
    git clone https://github.com/cmangos/mangos-classic.git /opt/src/cmangos && \
    echo "Core Version: ${ENV_CORE_COMMIT_HASH}" && \
    if [ "$ENV_CORE_COMMIT_HASH" != "HEAD" ]; then echo "Switching to Commit: ${ENV_CORE_COMMIT_HASH}\n"; cd /opt/src/cmangos; git checkout ${ENV_CORE_COMMIT_HASH}; fi

# Build Software
RUN mkdir -p /opt/cmangos/logs /opt/src/cmangos/build && \
    cd /opt/src/cmangos/build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/opt/cmangos -DBUILD_LOGIN_SERVER=OFF -DBUILD_PLAYERBOT=OFF -DBUILD_AHBOT=OFF  && \
    make -j 2 && make install

# Prepare Config Files
RUN cd /opt/cmangos/etc && mv -v mangosd.conf.dist mangosd.conf && cp -v /opt/src/cmangos/src/game/AuctionHouseBot/ahbot.conf.dist.in ahbot.conf
RUN cd /opt/cmangos/etc && \
    sed -i 's/LogsDir \= ""/LogsDir \= "\/opt\/cmangos\/logs"/g' mangosd.conf && \
    sed -i 's/DataDir \= "."/DataDir \= "\/opt\/cmangos-data"/g' mangosd.conf && \
    sed -i 's/MaxPingTime \= 30/MaxPingTime \= 5/g' mangosd.conf && \
    sed -i 's/Console\.Enable \= 1/Console\.Enable \= 0/g' mangosd.conf

# Download base image ubuntu
FROM ubuntu:18.04

# Install dependencies for running CMaNGOSd.
RUN DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -q -y \
    binutils \
    libboost-dev \
    libboost-filesystem1.65.1 \
    libboost-program-options1.65.1 \
    libboost-regex1.65.1 \
    libboost-system1.65.1 \
    libboost-thread1.65.1 \
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

# Volume configuration
VOLUME ["/opt/cmangos/etc"]

# Fetch build arguments
ARG CORE_COMMIT_HASH=HEAD \
    DB_COMMIT_HASH=HEAD

# Env Variables
ENV TZ=Europe/Amsterdam \
    ENV_CORE_COMMIT_HASH=$CORE_COMMIT_HASH \
    ENV_DB_COMMIT_HASH=$DB_COMMIT_HASH \
    CHARACTERS_DB=classiccharacters \
    LOGS_DB=classiclogs \
    MANGOSD_DB=classicmangos \
    REALMD_DB=classicrealmd \
    DB_USER=mangos \
    DB_PASS=mangos \
    REALMD_USER=mangos \
    REALMD_PASS=mangos \
    DB_SERVER=database \
    REALMD_SERVER=database

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
EXPOSE 8085
