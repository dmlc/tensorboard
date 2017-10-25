#!/usr/bin/env bash

# make protobufs, for front-end logging
make all

if [ ! -d tensorboard-lite/ ]; then
  echo "Could not find submodule tensorboard-lite. Please use git clone --recursive instead."
  exit 1
fi

# init the backend
cd tensorboard-lite
git submodule init
git submodule update --recursive

# init tensorflow as external dependency of tensorboard's backend.
cd tensorflow
git submodule init
git submodule update --recursive
./configure

# build tensorboard backend
cd ..
bazel build -c opt tensorboard:tensorboard

# move backend runfiles into python/dist
cp -r ../tools/* bazel-bin/tensorboard/tools/
cp -r tensorflow/tools/python_bin_path.sh bazel-bin/tensorboard/tools/
# get .whl file in python/dist/
bash bazel-bin/tensorboard/tools/build_pip_package.sh ../python/dist/

# install
cd ..
pip install python/dist/*.whl

