import shutil
from tensorboard.summary import scalar
from tensorboard.src import summary_pb2
from tensorboard import FileWriter


def test_log_scalar_summary():
    logdir = './experiment/scalar'
    writer = FileWriter(logdir)
    for i in range(10):
        s = scalar('scalar', i)
        writer.add_summary(s, i+1)
    writer.flush()
    writer.close()


def test_scalar_summary():
    scalar_value = 1.0
    s = scalar('test_scalar', scalar_value)
    values = s.value
    assert len(values) == 1
    assert values[0].tag == 'test_scalar'
    assert values[0].simple_value == 1.0

    byte_str = s.SerializeToString()
    s_recovered = summary_pb2.Summary()
    s_recovered.ParseFromString(byte_str)
    assert values[0].tag == s_recovered.value[0].tag
    assert values[0].simple_value == s_recovered.value[0].simple_value


if __name__ == "__main__":
    test_log_scalar_summary()
    test_scalar_summary()
