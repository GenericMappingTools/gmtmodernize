#!/bin/bash --login
# Thanks to the build script of the gmt conda-forge package by ocefpaf:
# https://github.com/conda-forge/gmt-feedstock/

# Does not work inside environment for some reason.
# Need to find away to compile this more easily.
#LIBPATH=$CONDA_PREFIX
LIBPATH=$HOME/bin/anaconda/
GMTLIBPATH=$LIBPATH/lib
DATADIR=$HOME/data
DCWPATH=$DATADIR/dcw-gmt
GSHHGPATH=$DATADIR/gshhg-gmt
GMTREPO=gmt-trunk
CPU_COUNT=`nproc`

echo "$LIBPATH"

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
    echo ""
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
      -D DCW_ROOT=$DCWPATH \
      -D GSHHG_ROOT=$GSHHGPATH \
      ..

echo ""
echo "Build and install"
echo ""
make -j$CPU_COUNT && make install
