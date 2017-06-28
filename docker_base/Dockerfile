# Distributed under the terms of the Modified BSD License.
FROM intelligencelab/datascience_ape:latest

LABEL maintainer "haobibo@gmail.com"

USER root

COPY work /tmp/work/

# Install data science enviroment: Jupyter Notebook, Python/R packages
RUN  cd /tmp && mkdir -p $CONDA_DIR/etc/jupyter/ \
  && conda install -yq jupyter_nbextensions_configurator jupyter_contrib_nbextensions \
  && conda install -yq r-essentials `cat /tmp/work/list_conda_install.txt` \
  && conda clean -ya \
  && pip install -U jupyter_declarativewidgets `cat /tmp/work/list_pip_install.txt` \
  && jupyter serverextension enable  --sys-prefix --py declarativewidgets \
  && jupyter nbextension     install --sys-prefix --py declarativewidgets \
  && jupyter nbextension     enable  --sys-prefix --py declarativewidgets \
  && ( rm -rf /root/.* /tmp/.* /tmp/* || true ) && cd \
  && echo "Conda Information:" `conda info` `conda list`

