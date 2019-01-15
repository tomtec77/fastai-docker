# fastai-docker
Docker container with the setup for the fast.ai Deep Learning course.

Docker is an easy way to enable GPU support on Linux since only the NVIDIA GPU
driver is required on the *host* machine (the NVIDIA CUDA Toolkit does not need 
to be installed).

See this repo: https://github.com/NVIDIA/nvidia-docker for instructions on how to
set up the host and for example Dockerfiles.

Instead of building from scratch, you can use one of the CUDA images provided by
NVIDIA; see https://github.com/NVIDIA/nvidia-docker/wiki/CUDA for details. There
are three flavors of images: `base` and `runtime` are for running pre-built
applications, and `devel` includes the compiler toolchain, tools, headers and 
static libraries. We will start from the development image with CUDA 9.0 and 
cuDNN (based on Ubuntu 16.04).

Build the image with
``` bash
sudo docker build . -t tomtec/fastai-docker
```

To run the container:
``` bash
sudo docker run -ti -p 8888:8888 --rm --runtime=nvidia --user fastai tomtec/fastai-docker
```
