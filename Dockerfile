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
RUN useradd fastai && \
    mkdir -p /home/fastai && \
    chown -R fastai:fastai /home/fastai && \
    addgroup fastai staff && \
    echo 'fastai:fastai' | chpasswd

WORKDIR /home/fastai

# Install Miniconda3
ENV CONDA_DOWNLOAD_URL https://repo.anaconda.com/miniconda
ENV CONDA_INSTALLER Miniconda3-latest-Linux-x86_64.sh

RUN wget --progress=bar:force $CONDA_DOWNLOAD_URL/$CONDA_INSTALLER && \
    bash $CONDA_INSTALLER -b -p /home/fastai/miniconda3 && \
    echo 'export PATH=~/miniconda3/bin:$PATH' >> ~/.bashrc
RUN echo 'conda activate fastai' >> ~/.bashrc

# Clone the course repository
ENV FASTAI_REPO https://github.com/fastai/fastai.git

RUN git clone $FASTAI_REPO fastai-repo
RUN cd fastai-repo && /home/fastai/miniconda3/bin/conda env update

# Copy data files
ENV FASTAI_URL http://files.fast.ai

RUN cd ~ && mkdir data && cd data && \
    wget --progress=bar:force $FASTAI_URL/data/dogscats.zip && \
    unzip -q dogscats.zip

RUN cd /home/fastai/fastai-repo/courses/dl1/ && ln -s ~/data ./

# Jupyter notebook
RUN echo ". /home/fastai/miniconda3/etc/profile.d/conda.sh" >> ~/.bashrc
#RUN /bin/bash -c "/home/fastai/miniconda3/etc/profile.d/conda.sh"
#RUN cd && /home/fastai/miniconda3/bin/conda activate fastai && \
#    jupyter notebook --generate-config && \
#    echo "c.NotebookApp.ip = '*'" >> ~/.jupyter/jupyter_notebook_config.py && \
#    echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py && \
#    pip install ipywidgets && \
#    jupyter nbextension enable --py widgetsnbextension --sys-prefix

# Add Jupyterlab
#RUN conda install -c conda-forge jupyterlab

# Cleanup
rm ~/$CONDA_INSTALLER

EXPOSE 8888

CMD ["bash"]
