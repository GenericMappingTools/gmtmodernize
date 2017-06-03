#!/bin/bash --login
# Thanks to the build script of the gmt conda-forge package by ocefpaf:
# https://github.com/conda-forge/gmt-feedstock/

# To return a failure if any commands inside fail
set -e

PREFIX=$CONDA_PREFIX
GMTLIBPATH="$PREFIX/lib"
DATADIR="$PREFIX/share/coast"
GMTREPO=gmt-trunk
CPU_COUNT=`nproc`

echo ""
echo "Installing GMT from source to $GMTLIBPATH"
echo ""

# Download coastline data if it's not yet present
if [[ ! -d "$DATADIR" ]]; then
    echo ""
    echo "Downloading coastline data to $DATADIR"
    echo ""
    mkdir $DATADIR

    # GSHHG (coastlines, rivers, and political boundaries):
    EXT="tar.gz"
    GSHHG="gshhg-gmt-2.3.6"
    URL="ftp://ftp.soest.hawaii.edu/gmt/$GSHHG.$EXT"
    curl $URL > $GSHHG.$EXT
    tar xzf $GSHHG.$EXT
    cp $GSHHG/* $DATADIR/
    rm -r $GSHHG $GSHHG.$EXT

    # DCW (country polygons):
    DCW="dcw-gmt-1.1.2"
    URL="ftp://ftp.soest.hawaii.edu/gmt/$DCW.$EXT"
    curl $URL > $DCW.$EXT
    tar xzf $DCW.$EXT
    cp $DCW/* $DATADIR
    rm -r $DCW $DCW.$EXT
fi

export LDFLAGS="$LDFLAGS -L$PREFIX/lib -Wl,-rpath,$PREFIX/lib"

nc-config --libs

echo "Installing GMT to $PREFIX"

if [[ -d "$GMTREPO" ]]; then
    echo ""
    echo "Update SVN repo"
    echo ""
    cd $GMTREPO
    svn up
else
    echo ""
    echo "Checkout SVN repo"
    echo ""
    svn checkout -q svn://gmtserver.soest.hawaii.edu/gmt5/trunk $GMTREPO
    #svn checkout -q svn://gmtserver.soest.hawaii.edu/gmt5/tags/5.4.1 $GMTREPO
    cd $GMTREPO
fi

# Turn on modern mode compilation flag
cp cmake/ConfigUserTemplate.cmake cmake/ConfigUser.cmake
echo "add_definitions(-DTEST_MODERN)" >> cmake/ConfigUser.cmake

# Clean the build dir
if [[ -d build ]]; then
    echo ""
    echo "Remove build dir"
    rm -r build
fi

mkdir -p build && cd build

echo ""
echo "Running CMAKE"
echo ""
cmake -D CMAKE_INSTALL_PREFIX=$PREFIX \
      -D FFTW3_ROOT=$PREFIX \
      -D GDAL_ROOT=$PREFIX \
      -D NETCDF_ROOT=$PREFIX \
      -D DCW_ROOT=$DATADIR \
      -D GSHHG_ROOT=$DATADIR \
      -D GMT_LIBDIR=$GMTLIBPATH \
      ..

echo ""
echo "Build and install"
echo ""
make -j$CPU_COUNT && make install

# Workaround for https://github.com/travis-ci/travis-ci/issues/6522
# Turn off exit on failure.
set +e
