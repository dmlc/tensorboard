all: python/tensorboard/proto

clean:
	rm python/tensorboard/src/*_pb2.py

python/tensorboard/proto:
	protoc tensorboard/src/*.proto --python_out=python/
