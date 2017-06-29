# Distributed under the terms of the Modified BSD License.
FROM intelligencelab/datascience_ape:latest

LABEL maintainer "haobibo@gmail.com"

USER root

COPY work /tmp/work/

# Install data science enviroment: Jupyter Notebook, Python/R packages
RUN  cd /tmp \
  && ( cat /tmp/work/install_pip3.list | xargs -n 1 -L 1 pip install -U \
  &    R --quiet -e "x=scan('/tmp/work/install_R.list', what='character'); install.packages(x, repos='http://cran.us.r-project.org')" \
  &    wait ) \
  && conda install -yq `cat /tmp/work/install_conda.list` && conda clean -ya
  && jupyter serverextension enable  --sys-prefix --py declarativewidgets \
  && jupyter nbextension     install --sys-prefix --py declarativewidgets \
  && jupyter nbextension     enable  --sys-prefix --py declarativewidgets \
  && ( rm -rf /root/.* /tmp/.* /tmp/* || true ) && cd \
  && echo "@ Conda Information:" `conda info` `conda list`
