#!/usr/bin/env bash
echo "This script will now start all actions needed to create (C)MaNGOS Data files..."

echo "Build docker image ..."
./build_image.sh

echo "Build extractors ..."
./build_extractors.sh

echo "Extract all resources ..."
./extract_resources.sh

echo "All Done!"

exit 0