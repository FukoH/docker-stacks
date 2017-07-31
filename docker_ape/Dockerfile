# Distributed under the terms of the Modified BSD License.
FROM debian:stretch

LABEL maintainer "haobibo@gmail.com"

USER root

ENV SHELL=/bin/bash \
    DEBIAN_FRONTEND=noninteractive \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    CONDA_DIR=/opt/conda \
    PATH=/opt/conda/bin:$PATH \
    HOME_DIR=/root \
    DATA_DIR=/data

COPY work /tmp/work/

RUN cd /tmp && mkdir -p $HOME_DIR $DATA_DIR \
 && echo "######### Install OS unilities and setup some configurations..." \
 && echo "deb     http://cdn-fastly.deb.debian.org/debian stretch main"                   > /etc/apt/sources.list \
 && echo "deb     http://cdn-fastly.deb.debian.org/debian-security stretch/updates main" >> /etc/apt/sources.list \
 && apt-get -y update --fix-missing && apt-get -y dist-upgrade \
 && apt-get -qq install -y --no-install-recommends \
    apt-utils apt-transport-https ca-certificates lsb-release gnupg dirmngr \
    wget curl sudo locales openssh-client build-essential cmake unzip p7zip-full htop vim git \
 && echo "ALL	ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
 && echo "en_US.UTF-8 UTF-8"     > /etc/locale.gen && locale-gen \
 && mv /tmp/work/bash_profile /etc/bash_profile \
 && echo "[ \$BASH ] && [ -f /etc/bash_profile ] && . /etc/bash_profile"	>> /etc/bash.bashrc \
 && echo "[ \$BASH ] && [ -f /root/.bashrc ]     && . /root/.bashrc"		>> /etc/bash.bashrc \
 && echo "######### Install Python3 (Miniconda3), R, JDK, NodeJS, Jupyter, and enable IRkernel for Jupyter..." \
 && DISTRO=$(lsb_release -c -s) && ARCH=$(arch) && MINICONDA_FILE="Miniconda3-latest-Linux-${ARCH}.sh"  \
 && wget -qO- "https://deb.nodesource.com/gpgkey/nodesource.gpg.key"					| apt-key add - \
 && wget -qO- "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xAD5F960A256A04AF"	| apt-key add - \
 && echo "deb		https://deb.nodesource.com/node_8.x ${DISTRO} main"					>  /etc/apt/sources.list.d/nodesource.list \
 && echo "deb-src	https://deb.nodesource.com/node_8.x ${DISTRO} main"					>> /etc/apt/sources.list.d/nodesource.list \
 && echo "deb		https://cloud.r-project.org/bin/linux/debian ${DISTRO}-cran34/"		>  /etc/apt/sources.list.d/R-source.list   \
 && ( apt-get -y update && apt-get -qq install -y --no-install-recommends `cat /tmp/work/install_apt.list | cut -d '#' -f 1` \
 &    wget -qO- "https://repo.continuum.io/miniconda/$MINICONDA_FILE" -O conda.sh && bash /tmp/conda.sh -f -b -p $CONDA_DIR \
 &    wait ) \
 && apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* \
 && CONDA_PY_PKGS=`$CONDA_DIR/bin/conda list | grep "py3" | cut -d " " -f 1 | sed "/#/d;/conda/d;/pip/d;/setuptools/d;"` \
 && conda remove --force -yq $CONDA_PY_PKGS \
 && pip install -UIq --pre pip setuptools notebook jupyterhub jupyterlab ipywidgets $CONDA_PY_PKGS \
 && jupyter nbextension     enable  --sys-prefix --py widgetsnbextension \
 && jupyter serverextension enable  --sys-prefix --py jupyterlab \
 && jupyter labextension    install @jupyter-widgets/jupyterlab-manager \
 && conda config --system --set auto_update_conda false \
 && conda config --system --add channels "conda-forge"  \
 && conda clean -ya \
 && echo "options(repos=structure(c(CRAN='http://cran.us.r-project.org')))" >> /etc/R/Rprofile.site \
 && R -e "install.packages('devtools',quiet=T,clean=T);" \
 && R -e "devtools::install_github('IRkernel/IRkernel',quiet=T,clean=T);IRkernel::installspec(user=F)" \
 && ( type java && type R && R CMD javareconf || true ) \
 && mkdir -p $CONDA_DIR/etc/jupyter/ && mv /tmp/work/jupyter_notebook_config.json $CONDA_DIR/etc/jupyter/ \
 && mv /tmp/work/start-*.sh /usr/local/bin/ \
 && echo "######### Build and install tini, which will be set as container entry point later..." \
 && wget -qO- "https://github.com/krallin/tini/archive/v0.14.0.zip" -O tini.zip && unzip -q /tmp/tini.zip \
 && cmake /tmp/tini-* && make install && mv /tmp/tini /usr/local/bin/tini \
 && chmod +x /usr/local/bin/* \
 && echo "######### Clean up and display components version information..." \
 && ( rm -rf /root/.* /tmp/.* /tmp/* || true ) && cd \
 && echo "@ Version of Node/NPM:"  `node -v` `npm -v` \
 && echo "@ Version of Jupyter Notebook/JupyterHub/JupyterLab:" `jupyter notebook --version` `jupyterhub --version` `jupyter lab --version` \
 && echo "@ Version of Java (java/javac):" && java -version && javac -version \
 && echo "@ Version of R and IRkernel:" && R -e "R.version.string; installed.packages()['IRkernel','Version']" \
 && echo "@ Version of Conda & Python:" && conda info && conda list \
 && echo "@ Version of image: building finished at:" `date`

ENTRYPOINT ["tini", "--"]
WORKDIR $HOME_DIR
EXPOSE 8888
CMD ["/bin/bash", "/usr/local/bin/start-singleuser.sh"]
