FROM nvidia/cuda:9.0-cudnn7-devel

ARG DEBIAN_FRONTEND=noninteractive

# File badproxy adds a fix to an incorrect proxy configuration
COPY ./badproxy /etc/apt/apt.conf.d/99fixbadproxy

# Update base system and install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    apt-utils \
    git \
    unzip \
    vim \
    wget
RUN apt-get -y dist-upgrade -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
RUN apt-get install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
    qtdeclarative5-dev \
    qml-module-qtquick-controls

# Clean up
RUN  apt-get -y autoremove && \
     apt-get clean && \
     rm -rf /var/lib/apt/lists/*

# Create a default user and home directory
ENV NAME fastai
ENV HOME /home/$NAME
RUN useradd -d $HOME -s /bin/bash -u 10000 -U -p $NAME $NAME && \
    mkdir $HOME && \
    addgroup $NAME staff
    
COPY bashrc.sh $HOME/.bashrc
COPY code_data_download.sh $HOME/

RUN chown -R $NAME:$NAME $HOME

USER $NAME
WORKDIR $HOME

# Install Miniconda3
ENV CONDA_DOWNLOAD_URL https://repo.anaconda.com/miniconda
ENV CONDA_INSTALLER Miniconda3-latest-Linux-x86_64.sh

RUN wget --progress=bar:force $CONDA_DOWNLOAD_URL/$CONDA_INSTALLER && \
    bash $CONDA_INSTALLER -b -p $HOME/miniconda3

# Map this directory to a directory in the host for permanent data storage
RUN mkdir $HOME/course
VOLUME $HOME/course

# Cleanup
RUN rm $CONDA_INSTALLER

EXPOSE 8888

CMD ["bash"]
