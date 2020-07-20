# Pelias Valhalla Docker Baseimage

This repository contains the Pelias Valhalla Docker Baseimage. This image is identical to https://github.com/pelias/docker-baseimage but with the additional installation of [Valhalla](https://github.com/valhalla/valhalla).

If your container doesn't require `valhalla` then you can save RAM and disk by using the regular Pelias `baseimage` linked above instead.

## Build the image:

```bash
docker build -t pelias/valhalla_baseimage .
```

## Test the image:

> note: this requires a local directory /data/osm which contains a single .pbf file

Generate tiles:

```bash
docker run \
  --rm -it \
  -v '/data/osm:/data/valhalla' \
  -v '/data/osm:/data/openstreetmap' \
  pelias/valhalla_baseimage \
  /bin/bash -c './scripts/build_tiles.sh'
```

Export polylines:

```bash
docker run \
  --rm -it \
  -v '/data/osm:/data/valhalla' \
  -v '/data/osm:/data/polylines' \
  pelias/valhalla_baseimage \
  /bin/bash -c './scripts/export_edges.sh'
```
