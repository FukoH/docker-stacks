#!/bin/bash

set -e

vergte() {
    [ "$2" = "`echo -e "$1\n$2" | sort -V | head -n1`" ]
}

notebook_arg=""
( vergte `jupyter notebook --version` 5.0.0 ) && notebook_arg="${notebook_arg} --allow-root"


# Generate a SSH id for git if it does not exist.
[ -e ~/.ssh/id_rsa.pub ] || ssh-keygen -t rsa -b 4096 -N "" -C `hostname` -f ~/.ssh/id_rsa

eval HOME_DIR=/root
eval DATA_DIR=/data
[ -e $HOME_DIR/data ] || ln -s $DATA_DIR $HOME_DIR/data

exec jupyter notebook ${notebook_arg} $*
