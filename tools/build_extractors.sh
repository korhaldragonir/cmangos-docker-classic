#!/bin/bash
sudo docker run --rm -it -v "$(pwd)/output:/output" cmangos_builder /build.sh