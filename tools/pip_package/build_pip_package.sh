#!/usr/bin/env bash
# Copyright 2015 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================


set -e

function cp_external() {
  local src_dir=$1
  local dest_dir=$2
  for f in `find "$src_dir" -maxdepth 1 -mindepth 1 ! -name '*local_config_cuda*'`; do
    cp -R "$f" "$dest_dir"
  done
}

PLATFORM="$(uname -s | tr 'A-Z' 'a-z')"
function is_windows() {
  # On windows, the shell script is actually running in msys
  if [[ "${PLATFORM}" =~ msys_nt* ]]; then
    true
  else
    false
  fi
}

function main() {
  if [ $# -lt 1 ] ; then
    echo "No destination dir provided"
    exit 1
  fi

  DEST=$1
  TMPDIR='../python/tensorboard/'

  GPU_FLAG=""
  while true; do
    if [[ "$1" == "--gpu" ]]; then
      GPU_FLAG="--project_name tensorflow_gpu"
    fi
    shift

    if [[ -z "$1" ]]; then
      break
    fi
  done

  echo $(date) : "=== Using tmpdir: ${TMPDIR}"

  if [ ! -d bazel-bin/tensorflow ]; then
    echo "Could not find bazel-bin.  Did you run from the root of the build tree?"
    exit 1
  fi

  if is_windows; then
    rm -rf ./bazel-bin/tensorflow/tools/pip_package/simple_console_for_window_unzip
    mkdir -p ./bazel-bin/tensorflow/tools/pip_package/simple_console_for_window_unzip
    echo "Unzipping simple_console_for_windows.zip to create runfiles tree..."
    unzip -o -q ./bazel-bin/tensorflow/tools/pip_package/simple_console_for_windows.zip -d ./bazel-bin/tensorflow/tools/pip_package/simple_console_for_window_unzip
    echo "Unzip finished."
    # runfiles structure after unzip the python binary
    cp -R \
      bazel-bin/tensorflow/tools/pip_package/simple_console_for_window_unzip/runfiles \
      "${TMPDIR}"
    RUNFILES=bazel-bin/tensorflow/tools/pip_package/simple_console_for_window_unzip/runfiles
  elif [ ! -d bazel-bin/tensorflow/tools/pip_package/build_pip_package.runfiles/org_tensorflow ]; then
    # Really old (0.2.1-) runfiles, without workspace name.
    echo "Really old (0.2.1-) runfiles, without workspace name"
    cp -R \
      bazel-bin/tensorflow/tensorboard/tensorboard.runfiles \
      "${TMPDIR}"
    cp bazel-bin/tensorflow/tensorboard/tensorboard "${TMPDIR}"
    RUNFILES=bazel-bin/tensorflow/tensorboard/tensorboard.runfiles
  else
    if [ -d bazel-bin/tensorflow/tools/pip_package/build_pip_package.runfiles/org_tensorflow/external ]; then
      # Old-style runfiles structure (--legacy_external_runfiles).
      echo "Old-style runfiles structure (--nolegacy_external_runfiles)"
      cp -R \
        bazel-bin/tensorflow/tensorboard/tensorboard.runfiles \
        "${TMPDIR}"
      cp bazel-bin/tensorflow/tensorboard/tensorboard "${TMPDIR}"
    else
      # New-style runfiles structure (--nolegacy_external_runfiles).
      echo "New-style runfiles structure (--nolegacy_external_runfiles)"
      cp -R \
        bazel-bin/tensorflow/tensorboard/tensorboard.runfiles \
        "${TMPDIR}"
      cp bazel-bin/tensorflow/tensorboard/tensorboard "${TMPDIR}"
    fi
    RUNFILES=bazel-bin/tensorflow/tensorboard/tensorboard.runfiles
  fi

  cp ../tools/pip_package/MANIFEST.in ../python
  cp ../tools/pip_package/README ../python

  # Before we leave the top-level directory, make sure we know how to
  # call python.
  source tools/python_bin_path.sh

  pushd ${TMPDIR}
  rm -f MANIFEST
  cd ..
  # apply tensorboard-binary.path
  git apply ../tensorboard-binary.patch
  echo $(date) : "=== Building wheel"
  "${PYTHON_BIN_PATH:-python}" setup.py bdist_wheel ${GPU_FLAG} >/dev/null
  echo $(date) : "=== Output wheel file is in: ${DEST}"
}

main "$@"
