#!/bin/bash
if [[ $OSTYPE == darwin* ]]; then
    export CFLAGS="-headerpad_max_install_names"
    export CXXFLAGS=$CFLAGS
else
    export CFLAGS="-include $PWD/glibc-compat.h"
    # corrfunc makefile purges CFLAGS; fix it here.
    sed --in-place 's;CFLAGS:=;CFLAGS?=;' common.mk
fi

cp $RECIPE_DIR/../../glibc-compat.h .
cp $RECIPE_DIR/../../check-glibc.sh .

make install
$PYTHON setup.py install --single-version-externally-managed --record rec.txt

if [[ $OSTYPE != darwin* ]]; then
    bash check-glibc.sh $SP_DIR/Corrfunc || exit 1
fi
