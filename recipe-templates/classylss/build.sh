#!/bin/bash

pwd

if [[ $OSTYPE == darwin* ]]; then
     export CFLAGS="-headerpad_max_install_names"
     export CXXFLAGS=$CFLAGS
else
     export CFLAGS="-g -fPIC -include $PWD/glibc-compat.h"
fi

cp $RECIPE_DIR/glibc-compat.h .

# this uses CFLAGS for CCFLAG
cp $RECIPE_DIR/class.cfg depends/class.cfg

$PYTHON setup.py install --single-version-externally-managed --record rec.txt
