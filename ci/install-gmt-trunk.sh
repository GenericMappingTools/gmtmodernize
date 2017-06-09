#!/bin/bash --login
# Thanks to the build script of the gmt conda-forge package by ocefpaf:
# https://github.com/conda-forge/gmt-feedstock/

# To return a failure if any commands inside fail
set -e

PREFIX=$CONDA_PREFIX
DATA_PREFIX="$PREFIX/share/coast"
REPO=gmt-trunk

echo ""
echo "Installing GMT from source to $PREFIX"
echo "----------------------------------------------------"

# Download coastline data if it's not yet present
if [[ ! -d "$DATA_PREFIX" ]]; then
    echo "Downloading coastline data to $DATA_PREFIX"
    echo "----------------------------------------------------"

    mkdir $DATA_PREFIX

    # GSHHG (coastlines, rivers, and political boundaries):
    EXT="tar.gz"
    GSHHG="gshhg-gmt-2.3.6"
    URL="ftp://ftp.soest.hawaii.edu/gmt/$GSHHG.$EXT"
    curl $URL > $GSHHG.$EXT
    tar xzf $GSHHG.$EXT
    cp $GSHHG/* $DATA_PREFIX/
    rm -r $GSHHG $GSHHG.$EXT

    # DCW (country polygons):
    DCW="dcw-gmt-1.1.2"
    URL="ftp://ftp.soest.hawaii.edu/gmt/$DCW.$EXT"
    curl $URL > $DCW.$EXT
    tar xzf $DCW.$EXT
    cp $DCW/* $DATA_PREFIX
    rm -r $DCW $DCW.$EXT
fi

echo ""
echo "Checkout the SVN repo"
echo "----------------------------------------------------"
svn checkout -q svn://gmtserver.soest.hawaii.edu/gmt5/trunk $REPO

cd $REPO

cp cmake/ConfigUserTemplate.cmake cmake/ConfigUser.cmake

# Turn on modern mode compilation flag
echo "add_definitions(-DTEST_MODERN)" >> cmake/ConfigUser.cmake

# Clean the build dir
if [[ -d build ]]; then
    rm -r build
fi

mkdir -p build && cd build

cmake -D CMAKE_INSTALL_PREFIX=$PREFIX \
      -D GDAL_ROOT=$CONDA_PREFIX \
      -D NETCDF_ROOT=$CONDA_PREFIX \
      -D PCRE_ROOT=$CONDA_PREFIX \
      -D FFTW3_ROOT=$CONDA_PREFIX \
      -D ZLIB_ROOT=$CONDA_PREFIX \
      -D DCW_ROOT=$DATA_PREFIX \
      -D GSHHG_ROOT=$DATA_PREFIX \
      ..
echo ""
echo "Build and install"
echo "----------------------------------------------------"
make -j`nproc` && make install

# Workaround for https://github.com/travis-ci/travis-ci/issues/6522
# Turn off exit on failure.
set +e
