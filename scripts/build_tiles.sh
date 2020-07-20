#!/bin/bash
set -euxo pipefail

# ensure data dirs exists
VALHALLA_DATA_DIR=${VALHALLA_DATA_DIR:='/data/valhalla'}
mkdir -p "${VALHALLA_DATA_DIR}/valhalla_tiles"
mkdir -p "${VALHALLA_DATA_DIR}/tmp"

# valhalla writes files to the CWD
# so we switch directories to a temp path with sufficient drive space
# https://github.com/valhalla/docker/issues/42#issuecomment-411799151
VALHALLA_TMP_DIR=${VALHALLA_TMP_DIR:='/tmp/valhalla/tmp'}
mkdir -p "${VALHALLA_TMP_DIR}"

# PBF input dir (directory which is scanned for PBF files)
INPUT_DIR=${INPUT_DIR:='/data/openstreetmap'}

# enumerate a list of PBF files
shopt -s nullglob
PBF_FILES=(${INPUT_DIR}/*.pbf)

# ensure there is at least one PBF file in the osm directory
if [[ ${#PBF_FILES[@]} -eq 0 ]]; then
  2>&1 echo 'no *.pbf files found in /data/openstreetmap directory';
  exit 1;
fi

# change directory to the temp dir since Valhalla writes some files to CWD
# see: https://github.com/valhalla/docker/issues/42
cd "${VALHALLA_TMP_DIR}"

# generate tiles
# note: we should include ALL files in the array, not only the first
# note: it's not clear from the Valhalla docs if this is possible?
echo "generate tiles from ${PBF_FILES[0]}"
valhalla_build_tiles \
  -c '/code/valhalla.json' \
  "${PBF_FILES[0]}"
