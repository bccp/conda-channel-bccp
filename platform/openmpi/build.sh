#!/bin/bash

if [[ $OSTYPE == darwin* ]]; then
    # this may need to be done on linux too,
    # see https://github.com/ContinuumIO/anaconda-issues/issues/739
    export LDFLAGS="$LDFLAGS -Wl,-rpath,${CONDA_PREFIX}/lib"
fi

# don't know if this is useful.
export FCFLAGS="$FFLAGS"

./configure --prefix=$PREFIX \
            --disable-dependency-tracking \
            --enable-mpi-cxx \
            --enable-mpi-fortran

make -j$CPU_COUNT
make install
