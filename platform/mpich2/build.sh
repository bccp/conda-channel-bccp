#!/bin/bash

# don't know if this is useful.
export FCFLAGS="$FFLAGS"

./configure --enable-shared --prefix=$PREFIX "F77=$FC" "FCFLAGS=$FFLAGS" "BASH_SHELL=/bin/bash"
make
make install

rm -rf $PREFIX/share
rm -rf $PREFIX/sbin
if grep '/usr/local/src/conda-prefix' $PREFIX/bin/mpi*; then
    exit 1
fi
