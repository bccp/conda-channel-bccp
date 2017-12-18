#!/bin/bash

$PYTHON setup.py install --quiet --single-version-externally-managed --record rec.txt --offline

if [[ $OSTYPE != darwin* ]]; then
    cp $RECIPE_DIR/../../check-glibc.sh .
    bash check-glibc.sh $SP_DIR/$PKG_NAME || exit 1
fi
