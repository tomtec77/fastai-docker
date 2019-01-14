# fastai-docker
Docker container with the setup for the fast.ai Deep Learning course.

Docker is an easy way to enable GPU support on Linux since only the NVIDIA GPU
driver is required on the *host* machine (the NVIDIA CUDA Toolkit does not need 
to be installed).

Build the image with
``` bash
sudo docker build . -t tomtec/fastai-docker
```
