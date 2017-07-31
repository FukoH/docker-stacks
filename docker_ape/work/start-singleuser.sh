#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $DIR/start--pre.sh

notebook_arg=""

( ver_gte `jupyter notebook --version` 5.0.0 ) && notebook_arg="${notebook_arg} --allow-root"
[ -n "${USE_SSL:+x}" ] && notebook_arg="${notebook_arg} --NotebookApp.certfile=${NOTEBOOK_PEM_FILE}"
[ -n "${NOTEBOOK_DIR:+x}" ] && notebook_arg="${notebook_arg} --notebook-dir=${NOTEBOOK_DIR}"

exec jupyterhub-singleuser --ip=0.0.0.0 --port=8888 \
  --user=$JPY_USER \
  --cookie-name=$JPY_COOKIE_NAME \
  --base-url=$JPY_BASE_URL \
  --hub-prefix=$JPY_HUB_PREFIX \
  --hub-api-url=$JPY_HUB_API_URL \
  ${notebook_arg} \
  $@
