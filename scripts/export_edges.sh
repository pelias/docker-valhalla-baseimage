#!/bin/bash
set -euxo pipefail

# ensure data dirs exists
EXPORT_DIR=${EXPORT_DIR:='/data/polylines'}
mkdir -p "${EXPORT_DIR}"

# set 0sv filename
EXPORT_FILENAME=${EXPORT_FILENAME:='extract.0sv'}

# generate polylines file
echo "generate edges to ${EXPORT_DIR}/${EXPORT_FILENAME}"
valhalla_export_edges \
  --config '/code/valhalla.json' \
    > "${EXPORT_DIR}/${EXPORT_FILENAME}"
