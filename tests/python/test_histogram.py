from tensorboard import summary
from tensorboard import FileWriter
import numpy as np


def test_log_histogram_summary():
    logdir = './experiment/histogram'
    writer = FileWriter(logdir)
    for i in range(10):
        mu, sigma = i * 0.1, 1.0
        values = np.random.normal(mu, sigma, 10000)  # larger for better looking.
        hist = summary.histogram('discrete_normal', values)
        writer.add_summary(hist, i+1)
    writer.flush()
    writer.close()


def test_histogram_summary():
    mu, sigma = 0.1, 1.0
    values = np.random.normal(mu, sigma, 10)
    hist = summary.histogram('discrete_normal', values)
    assert len(hist.value) == 1
    assert hist.value[0].tag == 'discrete_normal'


if __name__ == "__main__":
    test_log_histogram_summary()
    test_histogram_summary()
