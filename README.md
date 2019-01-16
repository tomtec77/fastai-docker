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

To run the container as user `fastai`, mapping port 8888 through to the host and
directory `/home/user/data` to `/shared/data/` in the container,
``` bash
sudo docker run -ti -p 8888:8888 --rm --runtime=nvidia -v /home/user/data:/shared/data --user fastai tomtec/fastai-docker
```

To give user `fastai` ownership of the shared volume, you need to do the 
following on the host machine: create the directory to share, then change
ownership using the **numeric** user and group IDs to match those of the `fastai`
user in the container (which is 10000 as set in the `Dockerfile`):
``` bash
mkdir -p /home/user/data
sudo chown -R 10000:10000 /home/user/data
```
