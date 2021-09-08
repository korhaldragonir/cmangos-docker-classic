# Download base image ubuntu 18.04
FROM mariadb:10.5-bionic

# Fetch build arguments
ARG CORE_COMMIT_HASH=HEAD \
    DB_COMMIT_HASH=HEAD

# Set Timezone and Build arguments
ENV TZ=Europe/Amsterdam \
    ENV_CORE_COMMIT_HASH=$CORE_COMMIT_HASH \
    ENV_DB_COMMIT_HASH=$DB_COMMIT_HASH

# Install Software
RUN DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -q -y git tzdata ca-certificates && \
    rm -rf /var/lib/apt/lists/*
