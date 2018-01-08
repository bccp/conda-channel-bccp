#!/bin/bash

if [[ $OSTYPE == darwin* ]]; then
    # this may need to be done on linux too,
    # see https://github.com/ContinuumIO/anaconda-issues/issues/739
    export LDFLAGS="$LDFLAGS -Wl,-rpath,${CONDA_PREFIX}/lib"
fi

# don't know if this is useful.
export FCFLAGS="$FFLAGS"

cp $RECIPE_DIR/Makefile.local .

make

cp src/fastpm $PREFIX/bin/
cp src/fastpm-lua $PREFIX/bin/

