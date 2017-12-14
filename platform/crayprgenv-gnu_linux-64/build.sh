#!/bin/bash

mkdir -p $PREFIX/etc/conda/activate.d
install ${RECIPE_DIR}/activate-crayprgenv-gnu.sh $PREFIX/etc/conda/activate.d
