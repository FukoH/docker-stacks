# IntelligenceLab - Docker Images

This repository includes files and scripts to build Docker Images for Data Science Environment.

## How to use?

Simply pull images and start!
```
docker run -it --rm --name=DSX -p 8888:8888 intelligencelab/datascience_base start-notebook.sh
```
And then access `http://ip-address-of-server:8888/` in your browser.

## Docker Images

### datascience_ape (folder `docker_ape`)

[![](https://images.microbadger.com/badges/image/intelligencelab/datascience_ape.svg)](https://hub.docker.com/r/intelligencelab/datascience_ape/ "Click to view the image on DockerHub") [![](https://images.microbadger.com/badges/version/intelligencelab/datascience_ape.svg)](https://microbadger.com/images/intelligencelab/datascience_ape)

This docker image including basic environment to run a Jupyter Notebook (or JupyterHub) with Python 3.6, R 3.4, OpenJDK 8, NodeJS 9.

The images is built based on `ubuntu`, although only tested on x86 platform, it is expected to be able to run on ppc64le platform.

Although `conda` is installed, we do not recommend to use conda to install a lib/package, because:

- Conda does not reuse the existing system library yet, if a system lib is already installed, conda install it again.
- Conda does not provide a stable linux system library repository yet, for example, some lib works well on `debian:jessie` but fail on `debian:stretch`.

### datascience_base (folder `docker_base`)

[![](https://images.microbadger.com/badges/image/intelligencelab/datascience_base.svg)](https://hub.docker.com/r/intelligencelab/datascience_base/ "Click to view the image on DockerHub") [![](https://images.microbadger.com/badges/version/intelligencelab/datascience_base.svg)](https://microbadger.com/images/intelligencelab/datascience_base)

This docker image is built based on `docker_ape`, which install some frequent used Python/R packages and Jupyter Notebook extension.

## Customization

These images are highly customizable, if you find a system lib / Python module / R packages is missing,
you can easily add one in the `install_XX.list` in the `work` folder.
