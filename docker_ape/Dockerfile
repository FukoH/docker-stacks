# Distributed under the terms of the Modified BSD License.

# Debian Jessie debootstrap from 2017-02-27 
# https://github.com/docker-library/official-images/commit/aa5973d0c918c70c035ec0746b8acaec3a4d7777
FROM debian@sha256:52af198afd8c264f1035206ca66a5c48e602afb32dc912ebf9e9478134601ec4

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
 && echo "=============================> Install OS libraries and setup some configurations..." \
 && apt-get -y update --fix-missing && apt-get -y upgrade \
 && apt-get -qq install -y --no-install-recommends \
    apt-utils apt-transport-https ca-certificates lsb-release gnupg dirmngr wget locales sudo \
 && DISTRO=$(lsb_release -c -s) && ARCH=$(arch) \
 && echo "deb     http://cdn-fastly.deb.debian.org/debian ${DISTRO} main"					  >  /etc/apt/sources.list \
 && echo "deb     http://cdn-fastly.deb.debian.org/debian ${DISTRO}-backports main"           >> /etc/apt/sources.list \
 && echo "deb     http://cdn-fastly.deb.debian.org/debian-security ${DISTRO}/updates   main"  >> /etc/apt/sources.list \
 && echo "deb     https://deb.nodesource.com/node_8.x ${DISTRO} main"						  >  /etc/apt/sources.list.d/nodesource.list \
 && echo "deb-src https://deb.nodesource.com/node_8.x ${DISTRO} main"						  >> /etc/apt/sources.list.d/nodesource.list \
 && echo "deb     https://cloud.r-project.org/bin/linux/debian ${DISTRO}-cran34/"			  >  /etc/apt/sources.list.d/R-source.list   \
 && wget -qO- "https://deb.nodesource.com/gpgkey/nodesource.gpg.key"					| apt-key add - \
 && wget -qO- "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xAD5F960A256A04AF"	| apt-key add - \
 && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
 && echo "en_US.UTF-8 UTF-8"             >  /etc/locale.gen && locale-gen \
 && mv /tmp/work/bash_profile /etc/bash_profile \
 && echo "[ \$BASH ] && [ -f /etc/bash_profile ] && . /etc/bash_profile"	>> /etc/bash.bashrc \
 && echo "[ \$BASH ] && [ -f /root/.bashrc ]     && . /root/.bashrc"		>> /etc/bash.bashrc \
 && echo "ALL	ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
 && echo "=============================> Install OS libs, Utilities, Python3 (Miniconda3), R, JDK, NodeJS, Jupyter..." \
 && apt-get clean && rm -rf /var/lib/apt/lists/* && apt-get -y update --fix-missing && apt-get -y upgrade \
 && apt-get -qq install -y --no-install-recommends `cat /tmp/work/install_apt.list | cut -d '#' -f 1` \
 && apt-get -qq install -t ${DISTRO}-backports openjdk-8-jdk-headless \
 && apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* \
 && wget -qO- "https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-${ARCH}.sh" -O conda.sh && bash /tmp/conda.sh -f -b -p $CONDA_DIR \
 && ( type java && type R && R CMD javareconf || true ) \
 && echo "=============================> Replace conda packages with pip installed packages and configure conda..." \
 && CONDA_PY_PKGS=`$CONDA_DIR/bin/conda list | grep "py3" | cut -d " " -f 1 | sed "/#/d;/conda/d;/pip/d;/setuptools/d;"` \
 && conda remove --force -yq $CONDA_PY_PKGS \
 && pip install -UIq --pre pip setuptools notebook jupyterhub jupyterlab ipywidgets $CONDA_PY_PKGS \
 && conda config --system --prepend channels conda-forge \
 && conda config --system --set auto_update_conda false  \
 && conda config --system --set show_channel_urls true   \
 && conda clean -ya \
 && echo "=============================> Setup Jupyter: Configurations, Enable JupyterLab view..." \
 && mkdir -p $CONDA_DIR/etc/jupyter/ && mv /tmp/work/jupyter_notebook_config.json $CONDA_DIR/etc/jupyter/ \
 && jupyter serverextension enable  --sys-prefix --py jupyterlab \
 && echo "-----------------------------> Setup Jupyter: Enable ipywidgets extension..." \
 && jupyter nbextension     enable  --sys-prefix --py widgetsnbextension \
 && jupyter labextension    install @jupyter-widgets/jupyterlab-manager \
 && echo "-----------------------------> Setup Jupyter: Install Kernel: Bash..." \
 && pip install bash_kernel && python -m bash_kernel.install --sys-prefix \
 && echo "-----------------------------> Setup Jupyter: Install Kernel: NodeJS..." \
 && JUPYTER_KERNEL_DIR=`python -c "import sys; print(sys.prefix)"`/share/jupyter/kernels \
 && sudo npm install -g --unsafe-perm jupyter-nodejs && node `npm root -g`/jupyter-nodejs/install.js $JUPYTER_KERNEL_DIR/nodejs \
 && echo "-----------------------------> Setup Jupyter: Install Kernel: R..." \
 && echo "options(repos=structure(c(CRAN='http://cran.us.r-project.org')))" >> /etc/R/Rprofile.site \
 && R -e "install.packages('devtools',quiet=T,clean=T);" \
 && R -e "devtools::install_github('IRkernel/IRkernel',quiet=T,clean=T);IRkernel::installspec(user=F)" \
 && echo "=============================> Build and install tini, add starting scripts, which will be entry point later..." \
 && wget -qO- "https://github.com/krallin/tini/archive/v0.15.0.zip" -O tini.zip && unzip -q /tmp/tini.zip \
 && cmake /tmp/tini-* && make install && mv /tmp/tini /usr/local/bin/tini \
 && mv /tmp/work/start-*.sh /usr/local/bin/ && chmod +x /usr/local/bin/* \
 && echo "=============================> Clean up and display components version information..." \
 && ( rm -rf /root/.* /tmp/.* /tmp/* || true ) && cd \
 && echo "@ Version of Node/NPM:"  `node -v` `npm -v` \
 && echo "@ Version of Java (java/javac):" && java -version && javac -version \
 && echo "@ Version of R and IRkernel:" && R -e "R.version.string; installed.packages()['IRkernel','Version']" \
 && echo "@ Version of Conda & Python:" && conda info && conda list \
 && echo "@ Version of Jupyter Notebook/JupyterHub/JupyterLab:" `jupyter notebook --version` `jupyterhub --version` `jupyter lab --version` \
 && echo "@ Kernel information of Jupyter:" `jupyter kernelspec list` \
 && echo "@ Version of image: building finished at:" `date` `uname -a`

ENTRYPOINT ["tini", "--"]
WORKDIR $HOME_DIR
EXPOSE 8888
CMD ["/bin/bash", "/usr/local/bin/start-singleuser.sh"]
