# base image
FROM pelias/baseimage

# Ubuntu Bionic install scripts adapted from:
# https://github.com/valhalla/valhalla/blob/master/scripts/Ubuntu_Bionic_Install.sh

# apt dependencies
# note: this is done in one command in order to keep down the size of intermediate containers
RUN apt-get update && \
    apt-get install -y \
        mc cmake make libtool pkg-config g++ gcc jq lcov protobuf-compiler vim-common \
        libboost-all-dev libboost-all-dev libcurl4-openssl-dev zlib1g-dev liblz4-dev \
        libprotobuf-dev libgeos-dev libgeos++-dev libluajit-5.1-dev libspatialite-dev \
        libsqlite3-dev luajit wget libsqlite3-mod-spatialite spatialite-bin \
        autoconf automake libtool make gcc g++ lcov \
        libcurl4-openssl-dev libzmq3-dev libczmq-dev && \
    rm -rf /var/lib/apt/lists/*

# install prime server
RUN git clone https://github.com/kevinkreiser/prime_server.git /code/prime_server
WORKDIR /code/prime_server
RUN git submodule update --init --recursive
RUN ./autogen.sh && ./configure && make test -j8 && make install
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib/"

# install valhalla
RUN git clone https://github.com/valhalla/valhalla.git /code/valhalla
WORKDIR /code/valhalla
RUN git submodule update --init --recursive
RUN mkdir build
WORKDIR /code/valhalla/build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release -DENABLE_PYTHON_BINDINGS=0 -DENABLE_NODE_BINDINGS=0 && make -j$(nproc) && make install

# create a directory to store shared resources
RUN mkdir -p /usr/local/share/valhalla && chmod 777 /usr/local/share/valhalla

# switch to a regular user
USER pelias

# default working directory
WORKDIR /code

# copy scripts
COPY ./scripts /code/scripts

# generate a default valhalla config
# note: '/data/valhalla' is expected to be available on a mounted volume
RUN valhalla_build_config \
    --mjolnir-tile-dir '/data/valhalla/valhalla_tiles' \
    --mjolnir-tile-extract '/data/valhalla/valhalla_tiles.tar' \
    --mjolnir-timezone '/usr/local/share/valhalla/timezones.sqlite' \
    --mjolnir-admin '/usr/local/share/valhalla/admins.sqlite' > /code/valhalla.json
