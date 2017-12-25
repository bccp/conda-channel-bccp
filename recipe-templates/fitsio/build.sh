#!/bin/bash

# add libm see https://github.com/esheldon/fitsio/pull/135
patch < $RECIPE_DIR/patch.libm

python setup.py install
