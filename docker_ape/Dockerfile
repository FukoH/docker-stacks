# Distributed under the terms of the Modified BSD License.
FROM debian:stretch

LABEL maintainer "haobibo@gmail.com"

USER root

ENV SHELL=/bin/bash \
    DEBIAN_FRONTEND=noninteractive \
    CONDA_DIR=/opt/conda \
    PATH=/opt/conda/bin:$PATH \
    HOME_DIR=/root \
    DATA_DIR=/data

COPY work /tmp/work/

RUN cd /tmp && mkdir -p $HOME_DIR $DATA_DIR \
 && echo "###### Install OS unilities and setup some configurations..." \
 && echo "deb     http://cdn-fastly.deb.debian.org/debian stretch main"                   > /etc/apt/sources.list \
 && echo "deb     http://cdn-fastly.deb.debian.org/debian-security stretch/updates main" >> /etc/apt/sources.list \
 && apt-get update --fix-missing && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    apt-utils apt-transport-https ca-certificates lsb-release gnupg dirmngr \
    wget curl sudo locales openssh-client build-essential cmake \
    unzip p7zip-full vim git htop \
 && echo "ALL	ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
 && echo "LANGUAGE=en_US.UTF-8" >> /etc/default/locale \
 && echo "LC_ALL=en_US.UTF-8"   >> /etc/default/locale \
 && echo "LC_TYPE=en_US.UTF-8"  >> /etc/default/locale \
 && echo "en_US.UTF-8 UTF-8"     > /etc/locale.gen && locale-gen \
 && mv /tmp/work/bash_profile /etc/bash_profile \
 && echo "[ \$BASH ] && [ -f /etc/bash_profile ] && . /etc/bash_profile" >> /etc/bash.bashrc \
 && echo "[ \$BASH ] && [ -f /root/.bashrc ]     && . /root/.bashrc"     >> /etc/bash.bashrc \
 && echo "###### Build and install tini, which will be set as container entry point later..." \
 && wget -qO- "https://github.com/krallin/tini/archive/v0.14.0.zip" -O tini.zip && unzip -q /tmp/tini.zip \
 && cmake /tmp/tini-* && make install && mv /tmp/tini /usr/local/bin/tini && chmod +x /usr/local/bin/tini \
 && echo "###### Install Python3 (Miniconda3), R, NodeJS; Install Jupyter Notebook and enable IRkernel for Jupyter..." \
 && DISTRO=$(lsb_release -c -s) && ARCH=$(arch) && MINICONDA_FILE="Miniconda3-latest-Linux-${ARCH}.sh"  \
 && wget -qO- "https://deb.nodesource.com/gpgkey/nodesource.gpg.key"                    | apt-key add - \
 && wget -qO- "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xAD5F960A256A04AF" | apt-key add - \
 && echo "deb     https://deb.nodesource.com/node_8.x ${DISTRO} main"                   >  /etc/apt/sources.list.d/nodesource.list \
 && echo "deb-src https://deb.nodesource.com/node_8.x ${DISTRO} main"                   >> /etc/apt/sources.list.d/nodesource.list \
 && echo "deb     https://cloud.r-project.org/bin/linux/debian ${DISTRO}-cran34/"       >  /etc/apt/sources.list.d/R-source.list   \
 && ( apt-get update && apt-get install -yq --no-install-recommends `cat /tmp/work/install_apt.list | cut -d '#' -f 1` \
 &    wget -qO- "https://repo.continuum.io/miniconda/$MINICONDA_FILE" -O conda.sh && bash /tmp/conda.sh -f -b -p $CONDA_DIR \
 &    wait ) \
 && conda config --system --set auto_update_conda false \
 && conda config --system --add channels "conda-forge"  \
 && conda clean -ya \
 && apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* \
 && CONDA_PY_PKGS=`$CONDA_DIR/bin/conda list | grep "py3" | cut -d " " -f 1 | sed "/#/d;/conda/d;/pip/d;/setuptools/d;"` \
 && conda remove --force -yq $CONDA_PY_PKGS \
 && pip install -U --quiet --ignore-installed pip setuptools $CONDA_PY_PKGS \
 && pip install -U --quiet notebook jupyterhub jupyterlab \
 && R -e "install.packages('devtools', repos='http://cran.us.r-project.org');"              > /dev/null \
 && R -e "devtools::install_github('IRkernel/IRkernel'); IRkernel::installspec(user=FALSE)" > /dev/null \
 && mkdir -p $CONDA_DIR/etc/jupyter/ && mv /tmp/work/jupyter_notebook_config.json $CONDA_DIR/etc/jupyter/ \
 && mv /tmp/work/start-*.sh /usr/local/bin/ && chmod +x /usr/local/bin/*.sh \
 && ( rm -rf /root/.* /tmp/.* /tmp/* || true ) && cd \
 && echo "@ Version of Node/NPM:"  `node -v` `npm -v` \
 && echo "@ Version of Jupyter Notebook/JupyterHub/JupyterLab:" `jupyter notebook --version` `jupyterhub --version` `jupyter lab --version` \
 && echo "@ Version of R and IRkernel:" && R -e "R.Version()\$version.string; installed.packages()['IRkernel','Version']" \
 && echo "@ Version of Conda & Python:" && conda info && conda list \
 && echo "@ Version of building: image building finished at:" `date`

ENTRYPOINT ["tini", "--"]
WORKDIR $HOME_DIR
EXPOSE 8888
CMD ["sh", "/usr/local/bin/start-singleuser.sh"]
