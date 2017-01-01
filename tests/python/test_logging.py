import os
import shutil
from tensorboard.summary import scalar
from tensorboard import FileWriter


def test_event_logging():
    logdir = './experiment/'
    summary_writer = FileWriter(logdir)
    scalar_value = 1.0
    s = scalar('test_scalar', scalar_value)
    summary_writer.add_summary(s, global_step=1)
    summary_writer.close()
    assert os.path.isdir(logdir)
    assert len(os.listdir(logdir)) == 1

    summary_writer = FileWriter(logdir)
    scalar_value = 1.0
    s = scalar('test_scalar', scalar_value)
    summary_writer.add_summary(s, global_step=1)
    summary_writer.close()
    assert os.path.isdir(logdir)
    assert len(os.listdir(logdir)) == 2

    # clean up.
    shutil.rmtree(logdir)


if __name__ == "__main__":
    test_event_logging()
