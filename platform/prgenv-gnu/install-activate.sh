#!/bin/bash

mkdir -p $PREFIX/etc/conda/activate.d
mkdir -p $PREFIX/etc/conda/deactivate.d

install ${RECIPE_DIR}/activate-nersc-prgenv-gnu.sh $PREFIX/etc/conda/activate.d
install ${RECIPE_DIR}/deactivate-nersc-prgenv-gnu.sh $PREFIX/etc/conda/deactivate.d
