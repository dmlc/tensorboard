#!/usr/bin/env bash

# make protobufs, for front-end logging
#make all

# add submodule
#git submodule add https://github.com/zihaolucky/tensorboard-lite.git tensorboard-lite
cd tensorboard-lite

# resolve dependency
#git submodule init
#git submodule update --recursive

# config tensorflow
cd tensorflow
#./configure

# build tensorboard backend
cd ..
#bazel build -c opt tensorboard:tensorboard

# move backend runfiles into python/dist
cp -r ../tools/* bazel-bin/tensorboard/tools/
cp -r tensorflow/tools/python_bin_path.sh bazel-bin/tensorboard/tools/
# get .whl file in python/dist/
bash bazel-bin/tensorboard/tools/build_pip_package.sh ../python/dist/

# install
cd ..
pip install python/dist/*.whl

