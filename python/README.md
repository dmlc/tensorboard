# TensorBoard for MXNet: Python Package

This package provides a python interface for **logging** different types of *summaries* for TensorBoard.

Currently, we support `scalar_summary` and `histogram`, the others would bring online soon.

### Usage

```python
from tensorboard import FileWriter

if __name__ == '__main__':
    # simple example for logging training speed and metrics.
    logdir = './experiment/'
    summary_writer = FileWriter(logdir)
    metric = NceAuc()
    model.fit(X = data_train,
              eval_metric = metric,
              batch_end_callback = mx.callback.Speedometer(summary_writer=summary_writer,
                                                           batch_size=batch_size,
                                                           frequent=50),)
                                                           
# modify your callback function to support tensorboard logging.
class Speedometer(object):
    """Calculate and log training speed periodically.

    Parameters
    ----------
    batch_size: int
        batch_size of data
    frequent: int
        How many batches between calculations.
        Defaults to calculating & logging every 50 batches.
    """
    def __init__(self, batch_size, frequent=50, summary_writer=None):
        self.batch_size = batch_size
        self.frequent = frequent
        self.init = False
        self.tic = 0
        self.last_count = 0
        self.summary_writer = summary_writer
        self.step = 0

    def __call__(self, param):
        """Callback to Show speed."""
        count = param.nbatch
        if self.last_count > count:
            self.init = False
        self.last_count = count

        if self.init:
            if count % self.frequent == 0:
                speed = self.frequent * self.batch_size / (time.time() - self.tic)
                if param.eval_metric is not None:
                    name_value = param.eval_metric.get_name_value()
                    param.eval_metric.reset()
                    for name, value in name_value:
                        logging.info('Epoch[%d] Batch [%d]\tSpeed: %.2f samples/sec\tTrain-%s=%f',
                                     param.epoch, count, speed, name, value)
                        if self.summary_writer is not None:
                            speed_summary = scalar(name='Training-Speed', scalar=speed)
                            metric_summary = scalar(name='Training-%s' %name, scalar=value)
                            self.step += 1
                            self.summary_writer.add_summary(speed_summary, global_step=self.step)
                            self.summary_writer.add_summary(metric_summary, global_step=self.step)
                else:
                    logging.info("Iter[%d] Batch [%d]\tSpeed: %.2f samples/sec",
                                 param.epoch, count, speed)
                    if self.summary_writer is not None:
                        speed_summary = scalar(name='Training-Speed', scalar=speed)
                        self.step += 1
                        self.summary_writer.add_summary(speed_summary, global_step=self.step)
                self.tic = time.time()
        else:
            self.init = True
            self.tic = time.time()
            
```

