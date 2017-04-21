#!/bin/bash --login
# Thanks to the build script of the gmt conda-forge package by ocefpaf:
# https://github.com/conda-forge/gmt-feedstock/

PREFIX=$CONDA_PREFIX
GMTPATH=$PREFIX

cd build

cmake -D CMAKE_INSTALL_PREFIX=$GMTPATH \
      -D FFTW3_ROOT=$PREFIX \
      -D GDAL_ROOT=$PREFIX \
      -D NETCDF_ROOT=$PREFIX \
      -D GMT_LIBDIR=$PREFIX/lib \
      -D DCW_ROOT=$DATADIR \
      -D GSHHG_ROOT=$DATADIR \
      ..
