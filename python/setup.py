# pylint: disable=invalid-name, exec-used
"""Setup tensorboard package."""
from __future__ import absolute_import
import os
from setuptools import setup

# Will be invoked which introduces dependencies
CURRENT_DIR = os.path.dirname(__file__)

__version__ = '0.1'

setup(name='tensorboard',
      version=__version__,
      description=open(os.path.join(CURRENT_DIR, 'README.md')).read(),
      install_requires=[
          'protobuf',
      ],
      zip_safe=False,
      packages=['tensorboard'],
      url='https://github.com/dmlc/tensorboard')
