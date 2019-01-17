#! /bin/bash

# Use this script to clone the course code repository, download the data files
# and set up the conda environment and Jupyter authentication.

FASTAI_URL=http://files.fast.ai
FASTAI_REPO=https://github.com/fastai/fastai.git
DIR=$HOME/course

if [[ ! -e $DIR ]]; then
    mkdir $DIR
fi

# Clone the repository and create the environment
cd $DIR
git clone $FASTAI_REPO fastai-repo
cd fastai-repo
conda env update

# Download and extract the data files
cd $DIR
if [[ ! -e $DIR/data ]]; then
    mkdir $DIR/data
fi

cd $DIR/data
wget --progress=bar:force $FASTAI_URL/data/dogscats.zip
unzip -q dogscats.zip
cd $DIR/fastai-repo/courses/dl1/
ln -s $DIR/data ./

# Install Jupyterlab
cd $HOME
conda activate fastai
conda install -c conda-forge jupyterlab

# Jupyter notebook configuration
jupyter notebook --generate-config
echo "c.NotebookApp.ip = '*'" >> $HOME/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> $HOME/.jupyter/jupyter_notebook_config.py
pip install ipywidgets
jupyter nbextension enable --py widgetsnbextension --sys-prefix
