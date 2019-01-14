FROM ubuntu:xenial

ARG DEBIAN_FRONTEND=noninteractive
ENV CUDA_DOWNLOAD_URL http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/
ENV CUDA_REPO_DEB cuda-repo-ubuntu1604_9.0.176-1_amd64.deb
ENV CUDA_KEY 7fa2af80.pub
ENV FASTAI_URL http://files.fast.ai/
ENV CUDNN_TARBALL cudnn-9.1-linux-x64-v7.tgz
ENV CUDA_HOME /usr/local/cuda/
ENV CONDA_DOWNLOAD_URL https://repo.continuum.io/miniconda/
ENV CONDA_INSTALLER Miniconda3-latest-Linux-x86_64.sh
ENV FASTAI_REPO https://github.com/fastai/fastai.git

# File badproxy adds a fix to an incorrect proxy configuration
COPY ./badproxy /etc/apt/apt.conf.d/99fixbadproxy

# Update base system
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    apt-utils unzip
RUN apt-get -y upgrade -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
RUN apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" qtdeclarative5-dev qml-module-qtquick-controls

# Create a default user and home directory
#RUN useradd fastai && \
#    mkdir -p /home/fastai && \
#    chown -R fastai:fastai /home/fastai && \
#    addgroup fastai staff && \
#    echo 'fastai:fastai' | chpasswd

# Install CUDA and CUDNN
#RUN add-apt-repository ppa:graphics-drivers/ppa -y && apt-get update
#RUN mkdir downloads && cd ~/downloads/ && \
#    wget --progress=bar:force $CUDA_DOWNLOAD_URL/$CUDA_REPO_DEB && \
#    dpkg -i $CUDA_REPO_DEB
#RUN apt-key adv --fetch-keys $CUDA_DOWNLOAD_URL/$CUDA_KEY && \
#    apt-get update && \
#    apt-get install -y cuda
#RUN wget --progress=bar:force $FASTAI_URL/files/$CUDNN_TARBALL && \
#    tar xf $CUDNN_TARBALL
#RUN cp cuda/include/*.* $CUDA_HOME/include/ && \
#    cp cuda/lib64/*.* $CUDA_HOME/lib64/

# Install Miniconda3
#RUN wget --progress=bar:force $CONDA_DOWNLOAD_URL/$CONDA_INSTALLER && \
#    bash $CONDA_INSTALLER -b -p /home/fastai/miniconda3
#RUN cd /home/fastai && \
#    git clone $FASTAI_REPO && \
#    cd fastai/ && \
#    echo 'export PATH=~/miniconda3/bin:$PATH' >> ~/.bashrc && \
#    export PATH=~/miniconda3/bin:$PATH && \
#    source ~/.bashrc

#RUN mkdir /home/data && cd data && \
#    wget --progress=bar:force $FASTAI_URL/data/dogscats.zip && \
#    unzip -q dogscats.zip

#RUN cd /home/fastai/courses/dl1/ && ln -s ~/data ./ && \
#    jupyter notebook 

# Clean up
#RUN  apt-get -y autoremove && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

CMD ["bash"]
