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
  && ( conda install -yq r-essentials \
  &    conda install -yq `cat /tmp/work/list_conda_install.txt` \
  &    wait ) \
  && conda remove -yq --force readline \
  && pip install --quiet --no-cache-dir jupyter_declarativewidgets `cat /tmp/work/list_pip_install.txt` \
  && conda clean -ya \
  && echo "Jupyter Notebook Version:" `jupyter notebook --version` \
  && jupyter serverextension enable  --sys-prefix --py declarativewidgets \
  && jupyter nbextension     install --sys-prefix --py declarativewidgets \
  && jupyter nbextension     enable  --sys-prefix --py declarativewidgets \
  && ls -A1 | xargs rm -rf && rm -rf /root/.cache && cd \
  && mkdir -p $HOME_DIR $DATA_DIR $HOME_DIR/share

EXPOSE 8888
WORKDIR $HOME_DIR

# Configure container startup
CMD ["sh", "/usr/local/bin/start-singleuser.sh"]
