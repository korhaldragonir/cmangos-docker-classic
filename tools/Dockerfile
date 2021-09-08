# Download base image ubuntu
FROM ubuntu:18.04

# Set Timezone
ENV TZ Europe/Amsterdam

# Update Ubuntu Software repository
RUN apt update

# Install nginx, php-fpm and supervisord from ubuntu repository
RUN DEBIAN_FRONTEND=noninteractive apt install -q -y git-core build-essential binutils gcc g++ cpp automake autoconf make libmysql++-dev libtool libssl-dev libcurl4-openssl-dev unrar-free unzip patch zlibc libc6 openssl pkg-config cmake libboost-dev libboost-program-options-dev libboost-system-dev libboost-thread-dev libboost-dev libboost-filesystem-dev libboost-regex-dev libpthread-stubs0-dev wget && \
    rm -rf /var/lib/apt/lists/*

# Prepare new cmake
RUN cd /tmp && wget --no-check-certificate https://github.com/Kitware/CMake/releases/download/v3.16.2/cmake-3.16.2-Linux-x86_64.tar.gz && \
    tar -xvzf cmake-3.16.2-Linux-x86_64.tar.gz && \
    mv /tmp/cmake-3.16.2-Linux-x86_64 /opt/cmake && \
    ln -s /opt/cmake/bin/* /usr/local/bin/ && \
    rm -f /tmp/cmake-3.16.2-Linux-x86_64.tar.gz

COPY build_script.sh /build.sh
RUN chmod 0755 /build.sh