# Distributed under the terms of the Modified BSD License.
FROM intelligencelab/datascience_ape:latest

LABEL maintainer "haobibo@gmail.com"

USER root

ENV HOME_DIR=/root \
    DATA_DIR=/data

COPY work /tmp/work/

# Install data science enviroment: Jupyter Notebook, Python/R packages
RUN cd /tmp \
  && mkdir -p $CONDA_DIR/etc/jupyter/ \
  && mv /tmp/work/jupyter_notebook_config.json $CONDA_DIR/etc/jupyter/ \
  && mv /tmp/work/start-*.sh /usr/local/bin/ && chmod +x /usr/local/bin/*.sh \
  && conda install -yq jupyter jupyterhub jupyterlab jupyter_nbextensions_configurator jupyter_contrib_nbextensions \
  && echo "Jupyter Notebook Version:" `jupyter notebook --version` \
  && conda install -yq r-essentials `cat /tmp/work/list_conda_install.txt` \
  && echo "R Version Information:" `R --version` \
  && conda clean -ya \
  && pip install jupyter_declarativewidgets `cat /tmp/work/list_pip_install.txt` \
  && jupyter serverextension enable  --sys-prefix --py declarativewidgets \
  && jupyter nbextension     install --sys-prefix --py declarativewidgets \
  && jupyter nbextension     enable  --sys-prefix --py declarativewidgets \
  && ( rm -rf /root/.* /tmp/.* /tmp/* || true ) && cd \
  && mkdir -p $HOME_DIR $DATA_DIR

EXPOSE 8888
WORKDIR $HOME_DIR

# Configure container startup
CMD ["sh", "/usr/local/bin/start-singleuser.sh"]
