#!/bin/bash

# add libm see https://github.com/esheldon/fitsio/pull/135
patch < $RECIPE_DIR/patch.libm || echo Patch failed.

$PYTHON setup.py install
