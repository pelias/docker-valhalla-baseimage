#!/bin/bash
set -euxo pipefail

# download URLS
URL_ADMINS='https://data.geocode.earth/valhalla/admin_2017_12_25-23_50_01.sqlite'
URL_TIMEZONES='https://data.geocode.earth/valhalla/tz_world_2017_12_25-23_50_01.sqlite'

# create database directory
DB_DIR=${DB_DIR:='/usr/local/share/valhalla'}
mkdir -p "${DB_DIR}" && chmod 777 "${DB_DIR}"

# download optional sqlite databases (optional)
curl -Lo "${DB_DIR}/admins.sqlite" "${URL_ADMINS}"
curl -Lo "${DB_DIR}/timezones.sqlite" "${URL_TIMEZONES}"
