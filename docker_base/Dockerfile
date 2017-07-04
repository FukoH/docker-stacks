# Distributed under the terms of the Modified BSD License.
FROM intelligencelab/datascience_ape:latest

LABEL maintainer "haobibo@gmail.com"

USER root

COPY work /tmp/work/

# Install data science enviroment: Python/R packages, and related lib dependencies.
RUN  cd /tmp && apt-get update --fix-missing \
  && apt-get install `cat /tmp/work/install_apt.list | cut -d '#' -f 1` \
  && apt-get clean && rm -rf /var/lib/apt/lists/ \
  && ( if [ `arch` = "x86_64" ]; then conda install -yq mkl; fi ) \
  && pip_install_file() { cat $2 | cut -d "%" -f 1 | sed '/^$/d' | xargs -n1 pip install --quiet $1; } \
  && ( npm install --global webpack bower \
  &    R -e "install.packages(scan('/tmp/work/install_R.list', what='character'), repos='http://cran.us.r-project.org')" &> /dev/null \
  &    conda install -yq `cat /tmp/work/install_conda.list | cut -d '#' -f 1` && conda clean -ya \
  &    pip_install_file -U /tmp/work/install_pip3.list \
  &    wait ) \
  && pip_install_file -e /tmp/work/install_pip_git.list \
  && echo "@ Version of installed R libraries:"       && R -q -e "R.Version()\$version.string; installed.packages()[,c(1,3:5,10)]" \
  && echo "@ Version of installed Conda/Py packages:" && conda info && conda list \
  && jupyter nbextensions_configurator enable --sys-prefix \
  && jupyter contrib nbextension install --sys-prefix \
  && jupyter nbextension     enable  --sys-prefix --py widgetsnbextension \
  && jupyter serverextension enable  --sys-prefix --py ipyparallel \
  && jupyter nbextension     install --sys-prefix --py ipyparallel \
  && jupyter nbextension     enable  --sys-prefix --py ipyparallel \
  && jupyter serverextension enable  --sys-prefix --py declarativewidgets \
  && jupyter nbextension     install --sys-prefix --py declarativewidgets \
  && jupyter nbextension     enable  --sys-prefix --py declarativewidgets \
  && ( rm -rf /root/.* /tmp/.* /tmp/* || true ) && cd \
  && echo "@ Jupyter Extension list" && jupyter nbextension list && jupyter serverextension list \
  && echo "@ Version of building: image building finished at:" `date`
