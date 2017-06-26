# Distributed under the terms of the Modified BSD License.
FROM ubuntu:latest

LABEL maintainer "haobibo@gmail.com"

USER root

ENV SHELL=/bin/bash \
    DEBIAN_FRONTEND=noninteractive \
    CONDA_DIR=/opt/conda \
    PATH=/opt/conda/bin:$PATH

# Install all OS dependencies, conda, Python (3 only), R, and NodeJS (and bower)
RUN apt-get update --fix-missing && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends apt-utils wget curl sudo \
 && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
 && apt-get install -yq --no-install-recommends \
    locales tzdata ca-certificates openssh-client libaio1 libav-tools libxrender1 \
    build-essential cmake gfortran python-dev unzip bzip2 p7zip-full vim git nodejs npm \
 && apt-get autoremove && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && [ -e /usr/bin/node ] || ln -s /usr/bin/nodejs /usr/bin/node \
 && echo "LANGUAGE=en_US.UTF-8" >> /etc/default/locale \
 && echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale \
 && echo "LC_TYPE=en_US.UTF-8" >> /etc/default/locale \
 && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen \
 && echo "ALL            ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers \
 && cd /tmp \
 && MINICONDA_FILE="Miniconda3-latest-Linux-`arch`.sh" \
 && ( npm install -g bower \
 &    wget --quiet "https://repo.continuum.io/miniconda/$MINICONDA_FILE" \
 &    wget --quiet https://github.com/krallin/tini/archive/v0.14.0.zip -O tini.zip \
 &    wait ) \
 && /bin/bash $MINICONDA_FILE -f -b -p $CONDA_DIR \
 && conda config --system --set auto_update_conda false \
 && echo "defaults r conda-forge" | xargs -n1 conda config --system --add channels \
 && conda install -qy r-base \
 && conda clean -tipsy \
 && $CONDA_DIR/bin/pip freeze --local | grep -v '^\-e' | cut -d = -f 1 | sed "/conda/d;" | xargs -n1 -P8 pip install -U --quiet --ignore-installed \
 && unzip -q tini.zip && cd tini* && cmake . && make install \
 && mv ./tini /usr/local/bin/tini && chmod +x /usr/local/bin/tini \
 && cd && rm -rf /tmp && mkdir /tmp && chmod 777 /tmp

ENTRYPOINT ["tini", "--"]
