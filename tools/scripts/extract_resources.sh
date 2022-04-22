#!/bin/bash

#### Settings ####

# Set current directory in case the script needs to find it.
CURRENT_DIR=$(pwd)

# Absolute or Relative path to the WotLK Game Client (Absolute path is advised)
PATH_TO_CLIENT=/home/mangos/wow-classic

# Absolute or Relative path to the CMaNGOS Core Repo (Absolute path is advised)
PATH_TO_CORE=/home/mangos/mangos-classic

# Absolute or Relative path to the built extractors (Absolute path is advised). By default located in the output directory.
PATH_TO_EXTRACTORS=/home/mangos/cmangos-docker-classic/tools/output/contrib/

########################## This is where the actual work begins ##########################

# Copy AD
cp -r ${PATH_TO_EXTRACTORS}/extractor/ad ${PATH_TO_CLIENT}/ad

# Copy VMAP
cp -r ${PATH_TO_EXTRACTORS}/vmap_extractor/vmapextract/vmap_extractor ${PATH_TO_CLIENT}/vmap_extractor
cp -r ${PATH_TO_EXTRACTORS}/vmap_assembler/vmap_assembler ${PATH_TO_CLIENT}/vmap_assembler

# Copy Move Map
cp -r ${PATH_TO_EXTRACTORS}/mmap/MoveMapGen ${PATH_TO_CLIENT}/MoveMapGen

# Copy Offmesh
cp -r ${PATH_TO_CORE}/contrib/extractor_scripts/offmesh.txt ${PATH_TO_CLIENT}/offmesh.txt

# Start Extraction
cd ${PATH_TO_CLIENT}/
# AD
./ad -f 0
# VMAP
./vmap_extractor -l
mkdir vmaps
./vmap_assembler Buildings vmaps
# MMAP
mkdir mmaps
./MoveMapGen --offMeshInput offmesh.txt

# Clean up
rm -r Buildings/
rm offmesh.txt
rm ad
rm vmap_assembler
rm vmap_extractor
rm MoveMapGen

tar -C ${PATH_TO_CLIENT} -cvf - dbc maps mmaps vmaps | gzip -9c > ${CURRENT_DIR}/cmangos-data.tar.gz

rm -rf ${PATH_TO_CLIENT}/dbc
rm -rf ${PATH_TO_CLIENT}/maps
rm -rf ${PATH_TO_CLIENT}/vmaps
rm -rf ${PATH_TO_CLIENT}/mmaps

########################## Finish ##########################
exit 0