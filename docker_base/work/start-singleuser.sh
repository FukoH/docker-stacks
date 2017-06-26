#!/bin/bash

set -e

if pgrep -x "jupyterhub-singleuser" > /dev/null;then
    echo "JupyterHub SingleUser is already running..."
    exit
fi

vergte() {
    [ "$2" = "`echo -e "$1\n$2" | sort -V | head -n1`" ]
}

notebook_arg=""
if ( vergte `jupyter notebook --version` 5.0.0 );then
    notebook_arg="${notebook_arg} --allow-root"
fi
if [ -n "${NOTEBOOK_DIR:+x}" ];then
    notebook_arg="${notebook_arg} --notebook-dir=${NOTEBOOK_DIR}"
fi

# Generate a SSH id for git if it does not exist.
[ -e ~/.ssh/id_rsa.pub ] || ssh-keygen -t rsa -b 4096 -N "" -C `hostname` -f ~/.ssh/id_rsa

eval HOME_DIR=/root
eval DATA_DIR=/data
[ -e $HOME_DIR/data ] || ln -s $DATA_DIR $HOME_DIR/data

exec jupyterhub-singleuser --ip=0.0.0.0 --port=8888 \
  --user=$JPY_USER \
  --cookie-name=$JPY_COOKIE_NAME \
  --base-url=$JPY_BASE_URL \
  --hub-prefix=$JPY_HUB_PREFIX \
  --hub-api-url=$JPY_HUB_API_URL \
  ${notebook_arg} \
  $@