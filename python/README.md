# TensorBoard for MXNet: Python Package

This package provides a python interface for **logging** different types of *summaries* for TensorBoard. It's slightly different from the origin ones.

Currently, we support `scalar_summary`, `histogram` and `image`, the others would coming soon.

### Usage

Basically, `SummaryWriter` provides `scalar`, `histogram` and `image` APIs for you.

```python
class SummaryWriter(object):
    """Writes `Summary` directly to event files.
    The `SummaryWriter` class provides a high-level api to create an event file in a
    given directory and add summaries and events to it. The class updates the
    file contents asynchronously. This allows a training program to call methods
    to add data to the file directly from the training loop, without slowing down
    training.
    """
    def __init__(self, log_dir):
        self.file_writer = FileWriter(logdir=log_dir)

    def add_scalar(self, name, scalar_value, global_step=None):
        self.file_writer.add_summary(scalar(name, scalar_value), global_step)

    def add_histogram(self, name, values):
        self.file_writer.add_summary(histogram(name, values))

    def add_image(self, tag, img_tensor):
        self.file_writer.add_summary(image(tag, img_tensor))

    def close(self):
        self.file_writer.flush()
        self.file_writer.close()

    def __del__(self):
        if self.file_writer is not None:
            self.file_writer.close()
```

Here's a MXNet callback for logging training/evaluation metrics using `SummaryWriter.add_scalar()`.

```python
import logging

class LogMetricsCallback(object):
    """Log metrics periodically in TensorBoard.
    This callback works almost same as `callback.Speedometer`, but write TensorBoard event file
    for visualization. For more usage, please refer https://github.com/dmlc/tensorboard

    Parameters
    ----------
    logging_dir : str
        TensorBoard event file directory.
        After that, use `tensorboard --logdir=path/to/logs` to launch TensorBoard visualization.
    prefix : str
        Prefix for a metric name of `scalar` value.
        You might want to use this param to leverage TensorBoard plot feature,
        where TensorBoard plots different curves in one graph when they have same `name`.
        The follow example shows the usage(how to compare a train and eval metric in a same graph).

    Examples
    --------
    >>> # log train and eval metrics under different directories.
    >>> training_log = 'logs/train'
    >>> evaluation_log = 'logs/eval'
    >>> # in this case, each training and evaluation metric pairs has same name, you can add a prefix
    >>> # to make it separate.
    >>> batch_end_callbacks = [mx.tensorboard.LogMetricsCallback(training_log)]
    >>> eval_end_callbacks = [mx.tensorboard.LogMetricsCallback(evaluation_log)]
    >>> # run
    >>> model.fit(train,
    >>>     ...
    >>>     batch_end_callback = batch_end_callbacks,
    >>>     eval_end_callback  = eval_end_callbacks)
    >>> # Then use `tensorboard --logdir=logs/` to launch TensorBoard visualization.
    """
    def __init__(self, logging_dir, prefix=None):
        self.prefix = prefix
        try:
            from tensorboard import SummaryWriter
            self.summary_writer = SummaryWriter(logging_dir)
        except ImportError:
            logging.error('You can install tensorboard via `pip install tensorboard`.')

    def __call__(self, param):
        """Callback to log training speed and metrics in TensorBoard."""
        if param.eval_metric is None:
            return
        name_value = param.eval_metric.get_name_value()
        for name, value in name_value:
            if self.prefix is not None:
                name = '%s-%s' % (self.prefix, name)
            self.summary_writer.add_scalar(name, value)
```

For more/simple usages, please check https://github.com/dmlc/tensorboard/tree/master/tests/python