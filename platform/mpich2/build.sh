#!/bin/bash

# pretend we are not in conda build
# to avoid special 'helpful' debug flags
# that breaks the mpicc/mpif90 wrappers.

export FFLAGS="-fopenmp -march=nocona -mtune=haswell -ftree-vectorize -fPIC -fstack-protector-strong -fno-plt -O2 -pipe"
export CFLAGS="-march=nocona -mtune=haswell -ftree-vectorize -fPIC -fstack-protector-strong -fno-plt -O2 -pipe"
export CXXFLAGS="-fvisibility-inlines-hidden -std=c++17 -fmessage-length=0 -march=nocona -mtune=haswell -ftree-vectorize -fPIC -fstack-protector-strong -fno-plt -O2 -pipe"

# don't know if this is useful.
export FCFLAGS="${FFLAGS}"

./configure --enable-shared --prefix=$PREFIX "F77=$FC" "BASH_SHELL=/bin/bash"
make
make install

rm -rf $PREFIX/share
rm -rf $PREFIX/sbin
