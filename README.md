# TensorBoard for MXNet

Bring [TensorBoard](https://github.com/tensorflow/tensorflow/tree/master/tensorflow/tensorboard) to MXNet.


### Build

Technically, TensorBoard has two parts:
 
 * Logging. See [Python interface](python/README.md), with this package you can utilize TensorBoard for various kinds of visualization tasks.
 * Rendering. Where you check your results from logging file.

Currently, we've finished some basic functions in logging part and the rendering part is still ongoing. 

This tool requires [Google protobuf](https://developers.google.com/protocol-buffers/?hl=en) compiler and its python binding.

1. Install the compiler:
  - Linux: install `protobuf-compiler` e.g. `sudo apt-get install protobuf-compiler` for Ubuntu and `sudo yum install protobuf-compiler` for Redhat/Fedora.
  - Windows: Download the win32 build of [protobuf](https://github.com/google/protobuf/releases). Make sure to download the version that corresponds to the version of the python binding on the next step. Extract to any location then add that location to your `PATH`
  - Mac OS X: `brew install protobuf`

2. Install the python binding by either `conda install -c conda-forge protobuf` or `pip install protobuf`.

3. Compile Caffe proto definition. Run `make` in Linux or Mac OS X, or `make_win32.bat` in Windows

After that, to build the first part, simply:

```
make
cd python
python setup.py install
```

### Usage

For logging, you can use the python package in your MXNet for logging some training/validation information, see [README](python/README.md) in Python package.

For rendering, you have to install tensorboard by yourself currently, as we're still working to provide an easy install solution.

Feel free to contribute your work and don't hesitate to discuss in issue with your ideas.