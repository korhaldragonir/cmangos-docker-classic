#!/bin/bash
CURRENT_DIR=$(pwd)
PATH_TO_CLIENT=../../wow-classic
PATH_TO_EXTRACTORS=./output/contrib/
PATH_TO_OFFMESH=../../mangos-classic/contrib/extractor_scripts/offmesh.txt

# Copy AD
cp -r ${PATH_TO_EXTRACTORS}/extractor/ad ${PATH_TO_CLIENT}/ad

# Copy VMAP
cp -r ${PATH_TO_EXTRACTORS}/vmap_extractor/vmapextract/vmap_extractor ${PATH_TO_CLIENT}/vmap_extractor
cp -r ${PATH_TO_EXTRACTORS}/vmap_assembler/vmap_assembler ${PATH_TO_CLIENT}/vmap_assembler

# Copy Move Map
cp -r ${PATH_TO_EXTRACTORS}/mmap/MoveMapGen ${PATH_TO_CLIENT}/MoveMapGen

# Copy Offmesh
cp -r ${PATH_TO_OFFMESH} ${PATH_TO_CLIENT}/offmesh.txt

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
mv -rf ${PATH_TO_CLIENT}/maps
mv -rf ${PATH_TO_CLIENT}/vmaps
mv -rf ${PATH_TO_CLIENT}/mmaps

# Finish
exit 0