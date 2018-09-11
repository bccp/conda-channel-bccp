#!/bin/bash

# we type these by hand instead of using the values 
# provided by conda-build:

# 1. to avoid special 'helpful' debug flags
# that breaks the mpicc/mpif90 wrappers.

# 2. also avoids many -f flags that causes a weird
# cmake `;list` conversion bug (either in cmake or the scripts)
# https://github.com/pytorch/pytorch/issues/8466

export FFLAGS="-fopenmp -march=nocona -mtune=haswell -fPIC -fstack-protector-strong -O2 -pipe"
export CFLAGS="-march=nocona -mtune=haswell -fPIC -fstack-protector-strong -O2 -pipe"
export CXXFLAGS="-std=c++17 -march=nocona -mtune=haswell -fPIC -fstack-protector-strong -O2 -pipe"

# don't know if this is useful.
export FCFLAGS="$FFLAGS"
export FC="$F90"

# don't know if this is useful.
export -n F90FLAGS
export -n F90

./configure --prefix=$PREFIX \
            --disable-dependency-tracking \
            --enable-cxx \
            --enable-f77 \
            --enable-fc

make -j$CPU_COUNT
make install

rm -rf $PREFIX/share
rm -rf $PREFIX/sbin
