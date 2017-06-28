# Distributed under the terms of the Modified BSD License.
FROM intelligencelab/datascience_ape:latest

LABEL maintainer "haobibo@gmail.com"

USER root

COPY work /tmp/work/

# Install data science enviroment: Jupyter Notebook, Python/R packages
RUN  cd /tmp \
  && R -e "x=scan('/tmp/work/list_R_install.txt', what='character'); install.packages(x, repos='http://cran.us.r-project.org')" \
  && pip   install -U  `cat /tmp/work/list_pip_install.txt`   \
  && conda install -yq `cat /tmp/work/list_conda_install.txt` \
  && conda clean -ya \
  && jupyter serverextension enable  --sys-prefix --py declarativewidgets \
  && jupyter nbextension     install --sys-prefix --py declarativewidgets \
  && jupyter nbextension     enable  --sys-prefix --py declarativewidgets \
  && ( rm -rf /root/.* /tmp/.* /tmp/* || true ) && cd \
  && echo "@ Conda Information:" `conda info` `conda list`
