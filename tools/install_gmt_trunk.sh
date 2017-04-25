#!/bin/bash --login
# Thanks to the build script of the gmt conda-forge package by ocefpaf:
# https://github.com/conda-forge/gmt-feedstock/

# Does not work inside environment for some reason.
# Need to find away to compile this more easily.
#LIBPATH=$CONDA_PREFIX
LIBPATH=${LIBPATH:-$HOME/bin/anaconda/}
GMTLIBPATH="$LIBPATH/lib"
DATADIR="$LIBPATH/share/coast"
GMTREPO=gmt-trunk
CPU_COUNT=`nproc`

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

export LDFLAGS="$LDFLAGS -L$LIBPATH/lib -Wl,-rpath,$LIBPATH/lib"

echo "Installing GMT to $LIBPATH"

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
    svn checkout svn://gmtserver.soest.hawaii.edu/gmt5/trunk $GMTREPO
    cd $GMTREPO
fi

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
cmake -D CMAKE_INSTALL_PREFIX=$LIBPATH \
      -D FFTW3_ROOT=$LIBPATH \
      -D GDAL_ROOT=$LIBPATH \
      -D NETCDF_ROOT=$LIBPATH \
      -D GMT_LIBDIR=$GMTLIBPATH \
      -D DCW_ROOT=$DATADIR \
      -D GSHHG_ROOT=$DATADIR \
      ..

echo ""
echo "Build and install"
echo ""
make -j$CPU_COUNT && make install
