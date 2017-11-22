#!/bin/bash

# fortran is used, so need this line

if [[ $OSTYPE == darwin* ]]; then
    export LDFLAGS="$LDFLAGS -Wl,-rpath,${CONDA_PREFIX}/lib"
fi

# this uses CFLAGS for CCFLAG
cp $RECIPE_DIR/class.cfg depends/class.cfg

$PYTHON setup.py install --single-version-externally-managed --record rec.txt

if [[ $OSTYPE != darwin* ]]; then
    cp $RECIPE_DIR/../../check-glibc.sh .
    bash check-glibc.sh $SP_DIR/$PKG_NAME || exit 1
fi
