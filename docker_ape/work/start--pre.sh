#!/bin/bash
set -e

# Utilities function to compare version.
vergte() {
    [ "$2" = "`echo -e "$1\n$2" | sort -V | head -n1`" ]
}

# Generate a SSH id for git if it does not exist.
[ -e ~/.ssh/id_rsa.pub ] || ssh-keygen -t rsa -b 4096 -N "" -C `hostname` -f ~/.ssh/id_rsa

# Generate a self-signed certificate for notebook if it does not exist.
NOTEBOOK_PEM_FILE="/opt/conda/etc/jupyter/notebook.pem"
[ -e $NOTEBOOK_PEM ] || openssl req -new -newkey rsa:2048 -days 356 -nodes -x509 -subj "/C=XX/ST=XX/L=XX/O=generated/CN=generated" \
  -keyout $NOTEBOOK_PEM_FILE -out $NOTEBOOK_PEM_FILE
chmod 600 $NOTEBOOK_PEM_FILE

# Generate a symlink of /data to /root/data
eval HOME_DIR=/root
eval DATA_DIR=/data
[ -e $HOME_DIR/data ] || ln -s $DATA_DIR $HOME_DIR/data
