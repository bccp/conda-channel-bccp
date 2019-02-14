
export NO_CUDA=1
export CMAKE_PREFIX_PATH=$PREFIX

export VERBOSE=1
$PYTHON setup.py install

echo -e "If you want to build libtorch, please do\n"
echo "cd <pytorch_root>"
echo "mkdir build_libtorch && cd build_libtorch"
echo "BUILD_TORCH=ON ONNX_NAMESPACE=onnx_torch bash ../tools/build_pytorch_libs.sh --use-nnpack caffe2"
echo -e "\nThen the output will be produced at torch/lib/tmp_install"
