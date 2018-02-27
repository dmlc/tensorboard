# Standalone TensorBoard

> TensorBoard is a suite of web applications for inspecting and understanding your TensorFlow runs and graphs. TensorBoard currently supports five visualizations: scalars, images, audio, histograms, and the graph.  

> This README gives an overview of key concepts in TensorBoard, as well as how to interpret the visualizations TensorBoard provides. For an in-depth example of using TensorBoard, see the tutorial: [TensorBoard: Visualizing Learning](https://www.tensorflow.org/versions/master/how_tos/summaries_and_tensorboard/index.html). For in-depth information on the Graph Visualizer, see this tutorial: [TensorBoard: Graph Visualization](https://www.tensorflow.org/versions/master/how_tos/graph_viz/index.html).  

## Installing from source
When installing from source you will build a pip wheel that you then install using pip. We provide a `installer.sh` and `build_pip_package.sh` for you to get that pip wheel.

We’re also working on providing a pre-built pip wheel for you, so you can install TensorBoard package more easily. We would let you know once we finish this feature but currently it has to be installed from source.

### Clone the TensorBoard repository

```bash
$ git clone https://github.com/dmlc/tensorboard.git
```

### Prepare environment for Linux

#### Install Protocol Compiler
Note that this requires [Protocol Buffers 3](https://developers.google.com/protocol-buffers/?hl=en) compiler, so please install it.

#### Install Bazel

We use Bazel 0.6.1 [here](https://github.com/bazelbuild/bazel/releases/tag/0.6.1)

#### Install other dependencies

```bash
# For Python 2.7:
$ sudo apt-get install python-numpy python-dev python-wheel python-mock python-protobuf
# For Python 3.x:
$ sudo apt-get install python3-numpy python3-dev python3-wheel python3-mock
# With a virtualenv (export needs to be done for subsequent builds, too):
$ pip install -r requirements.txt && export PYTHON_BIN_PATH=$VIRTUAL_ENV/bin/python
```

### Prepare environment for Mac OS X

#### Install Protocol Compiler

Note that this requires [Protocol Buffers 3](https://developers.google.com/protocol-buffers/?hl=en) compiler, so please install it.

#### Install Bazel

Follow instructions [here](http://bazel.build/docs/install.html) to install the
dependencies for bazel. You can then use homebrew to install bazel(here we use v0.6.1):

```bash
$ brew install bazel
```

#### Dependencies

You can install the python dependencies using easy_install or pip, or conda if you use Anaconda for virtual-env management. Using
conda, run

```bash
$ conda install six, numpy, wheel, protobuf
```

### Build 

After that, to build the first part, simply:

```bash
$ cd tensorboard
$ sh installer.sh
# In this process, it might need configuration or failed in bazel build, just retry the specific step.
```

#### Configure the installation

For example(just type ’N’ for all case as we don’t need them):

```bash
$ ./configure
Please specify the location of python. [Default is /usr/bin/python]:
Do you wish to build TensorFlow with Google Cloud Platform support? [y/N] N
No Google Cloud Platform support will be enabled for TensorFlow
Do you wish to build TensorFlow with GPU support? [y/N] N
Do you wish to build TensorFlow with OpenCL support? [y/N] N
```

## Usage
`dmlc/tensorboard` contains two parts in general, currently we have [Python interface](https://github.com/dmlc/tensorboard/tree/master/python) 
for writing/logging `scalar`, `histogram` and `image` data to `EventFile`, which the front-end load data from this event file for visualization.

Technically, we reuse the rendering part of original TensorBoard of TensorFlow, but rewrite the logging part in pure Python without touching the 
TensorFlow code. We've try to keep the concepts consistent but the logging API might has some slightly difference.

### Logging

See [README](python/README.md) in Python package.

### Rendering 

```bash
$ tensorboard --logdir=path/to/logs
``` 


## Contribute

You might want to see the development note of this project at our DMLC blog: [Bring TensorBoard to MXNet](http://dmlc.ml/2017/01/07/bring-TensorBoard-to-MXNet.html)

Feel free to contribute your work and don't hesitate to discuss in issue with your ideas.
