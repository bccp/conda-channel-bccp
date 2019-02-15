
export NO_CUDA=1
export CMAKE_PREFIX_PATH=$PREFIX

export VERBOSE=1
$PYTHON setup.py install

{
  {
  mkdir build_libtorch
  cd build_libtorch
  BUILD_TORCH=ON ONNX_NAMESPACE=onnx_torch bash ../tools/build_pytorch_libs.sh --use-nnpack caffe2
  } && {
  echo -e "\nSuccessfully built libtorch at `dirname $PWD`/torch/lib/tmp_install\n"
  }
} || {
  echo -e "\nError: failed to build libtorch"
}
