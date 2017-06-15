#!/bin/bash

set -e

if pgrep -x "jupyter-notebook" > /dev/null;then
    echo "Jupyter Notebook is already running..."
    exit
fi

vergte() {
    [ "$2" = "`echo -e "$1\n$2" | sort -V | head -n1`" ]
}

notebook_arg=""
if ( vergte `jupyter notebook --version` 5.0.0 );then
    notebook_arg="${notebook_arg} --allow-root"
fi

# Generate a SSH id for git if it does not exist.
[ -e ~/.ssh/id_rsa.pub ] || ssh-keygen -t rsa -b 4096 -N "" -C `hostname` -f ~/.ssh/id_rsa

exec jupyter notebook ${notebook_arg} $*
