
export NO_CUDA=1
export CMAKE_PREFIX_PATH=$PREFIX

export VERBOSE=1
patch -p1 -d third_party/gloo < ${RECIPE_DIR}/gloo-SPEED_UNKNOWN.patch
$PYTHON setup.py install
