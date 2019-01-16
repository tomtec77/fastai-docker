#! /bin/bash

# Use this script to clone the course code repository, download the data files
# and set up the conda environment and Jupyter authentication.

FASTAI_URL=http://files.fast.ai
FASTAI_REPO=https://github.com/fastai/fastai.git

# Clone the repository and create the environment
cd $HOME
git clone $FASTAI_REPO fastai-repo
cd fastai-repo
conda env update

# Download and extract the data files
mkdir $HOME/data
cd $HOME/data
wget --progress=bar:force $FASTAI_URL/data/dogscats.zip
unzip -q dogscats.zip
cd $HOME/fastai-repo/courses/dl1/
ln -s $HOME/data ./

# Install Jupyterlab
conda activate fastai
conda install -c conda-forge jupyterlab

# Jupyter notebook configuration
jupyter notebook --generate-config
echo "c.NotebookApp.ip = '*'" >> $HOME/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> $HOME/.jupyter/jupyter_notebook_config.py
pip install ipywidgets
jupyter nbextension enable --py widgetsnbextension --sys-prefix


