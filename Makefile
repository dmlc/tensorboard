all: python/tensorboard/protos

clean:
	rm python/tensorboard/src/*_pb2.py

python/tensorboard/protos:
	protoc src/types.proto --python_out=python/tensorboard
	protoc src/tensor_shape.proto --python_out=python/tensorboard
	protoc src/tensor.proto --python_out=python/tensorboard/
	protoc src/resource_handle.proto --python_out=python/tensorboard/
	protoc src/summary.proto --python_out=python/tensorboard/
	protoc src/event.proto --python_out=python/tensorboard/
