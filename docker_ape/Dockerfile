# Distributed under the terms of the Modified BSD License.
FROM debian:stretch

LABEL maintainer "haobibo@gmail.com"

USER root

ENV SHELL=/bin/bash \
    DEBIAN_FRONTEND=noninteractive \
    CONDA_DIR=/opt/conda \
    PATH=/opt/conda/bin:$PATH

COPY work /tmp/work/

# Install all OS dependencies, conda, Python (3 only), R, and NodeJS (and bower)
RUN REPO=http://cdn-fastly.deb.debian.org \
 && echo "deb $REPO/debian stretch main\ndeb $REPO/debian-security stretch/updates main" > /etc/apt/sources.list \
 && apt-get update --fix-missing && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends apt-utils wget curl \
 && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
 && apt-get install -yq --no-install-recommends \
    sudo locales tzdata ca-certificates openssh-client bzip2 unzip p7zip-full \
    build-essential cmake gfortran python-dev libssl-dev vim git nodejs \
    libaio1 libav-tools libxrender1 \
 && apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* \
 && [ -e /usr/bin/node ] || ln -s /usr/bin/nodejs /usr/bin/node \
 && [ -e /usr/bin/npm  ] || ln -s /usr/local/bin/npm /usr/bin/npm \
 && echo "#Version of Node and NPM:" `node -v` `npm -v` \
 && cd /tmp \
 && MINICONDA_FILE="Miniconda3-latest-Linux-`arch`.sh" \
 && ( npm install -g bower \
 &    wget --quiet "https://repo.continuum.io/miniconda/$MINICONDA_FILE" \
 &    wget --quiet "https://github.com/krallin/tini/archive/v0.14.0.zip" -O tini.zip \
 &    wait ) \
 && /bin/bash /tmp/$MINICONDA_FILE -f -b -p $CONDA_DIR \
 && pip install -U --quiet --ignore-installed `$CONDA_DIR/bin/pip freeze --local | grep -v '^\-e' | cut -d = -f 1 | sed "/conda/d;"` \
 && pip install -U --quiet notebook jupyterhub jupyterlab \
 && mv /tmp/work/start-*.sh /usr/local/bin/ && chmod +x /usr/local/bin/*.sh \
 && echo "#Version of Jupyter Notebook, JupyterHub, JupyterLab:" `jupyter notebook --version` `jupyterhub --version` `jupyter lab --version` \
 && echo "r conda-forge defaults" | xargs -n1 conda config --system --add channels \
 && conda config --system --set auto_update_conda false \
 && conda install -yq r-base r-irkernel \
 && conda clean -ya \
 && echo "#Version of R:" `R --version` \
 && echo "#Conda Information:" `conda info` `conda list` \
 && unzip -q tini.zip && cd tini* && cmake . && make install \
 && mv ./tini /usr/local/bin/tini && chmod +x /usr/local/bin/tini \
 && mv /root/.bashrc /etc/bash_profile && echo "[ \$BASH ] && [ -f /etc/bash_profile ] && . /etc/bash_profile" >> /etc/bash.bashrc \
 && echo "ALL            ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers \
 && echo "LANGUAGE=en_US.UTF-8" >> /etc/default/locale \
 && echo "LC_ALL=en_US.UTF-8"   >> /etc/default/locale \
 && echo "LC_TYPE=en_US.UTF-8"  >> /etc/default/locale \
 && echo "en_US.UTF-8 UTF-8"     > /etc/locale.gen && locale-gen \
 && ( rm -rf /root/.* /tmp/.* /tmp/* || true ) && cd

ENTRYPOINT ["tini", "--"]
