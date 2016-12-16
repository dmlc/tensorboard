#!/usr/bin/env bash

# get tensorflow
git clone https://github.com/tensorflow/tensorflow
cd tensorflow

# run configuration. TODO. how to automate this process?
sh ./configure
# build tensorboard
bazel build tensorflow/tensorboard:tensorboard

# prepare pip installation package
cp -r ../tools/ bazel-bin/tensorflow/tools/
# get .whl file in /tmp/tensorflow_pkg
sh bazel-bin/tensorflow/tools/pip_package/build_pip_package.sh /tmp/tensorflow_pkg

