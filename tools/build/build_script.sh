#!/bin/bash

# Fetch Source
git clone https://github.com/cmangos/mangos-classic.git /source

# Go to directory
cd /source

# Create build directory
mkdir build

# Go into build directory
cd build

# Configure sources
cmake .. -DBUILD_GAME_SERVER=OFF -DBUILD_LOGIN_SERVER=OFF -DBUILD_PLAYERBOT=OFF -DBUILD_AHBOT=OFF -DBUILD_EXTRACTORS=ON -DCMAKE_INSTALL_PREFIX=/source/build/extractors

# Build extractors
make -j 2

# Copy them to the output
cp -r /source/build/contrib/ /output

# Exit container
exit