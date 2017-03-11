from tensorboard import SummaryWriter
from tensorboard.summary import scalar
from tensorboard.src import summary_pb2


def test_log_scalar_summary():
    logdir = './experiment/scalar'
    writer = SummaryWriter(logdir)
    for i in range(10):
        writer.add_scalar('test_scalar', i+1)
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
