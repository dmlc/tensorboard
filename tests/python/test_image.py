from tensorboard import summary
from tensorboard import FileWriter
import numpy as np
import os
import urllib
import gzip
import struct


def download_data(url, force_download=False):
    fname = url.split("/")[-1]
    if force_download or not os.path.exists(fname):
        urllib.urlretrieve(url, fname)
    return fname


def read_data(label_url, image_url):
    with gzip.open(download_data(label_url)) as flbl:
        magic, num = struct.unpack(">II", flbl.read(8))
        label = np.fromstring(flbl.read(), dtype=np.int8)
    with gzip.open(download_data(image_url), 'rb') as fimg:
        magic, num, rows, cols = struct.unpack(">IIII", fimg.read(16))
        image = np.fromstring(fimg.read(), dtype=np.uint8).reshape(len(label), rows, cols)
    return (label, image)


def test_log_image_summary():
    logdir = './experiment/image'
    writer = FileWriter(logdir)

    path = 'http://yann.lecun.com/exdb/mnist/'
    (train_lbl, train_img) = read_data(
        path+'train-labels-idx1-ubyte.gz', path+'train-images-idx3-ubyte.gz')

    for i in range(10):
        tensor = np.reshape(train_img[i], (28, 28, 1))
        im = summary.image('mnist/'+str(i), tensor)  # in this case, images are grouped under `mnist` tag.
        writer.add_summary(im, i+1)
    writer.flush()
    writer.close()


if __name__ == "__main__":
    test_log_image_summary()
