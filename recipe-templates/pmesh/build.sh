#!/bin/bash

python setup.py install

if [[ $OSTYPE != darwin* ]]; then
    cp $RECIPE_DIR/../../check-glibc.sh .
    bash check-glibc.sh $SP_DIR/$PKG_NAME || exit 1
fi
