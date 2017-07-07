#!/bin/bash
source start--pre.sh

notebook_arg=""
( vergte `jupyter notebook --version` 5.0.0 ) && notebook_arg="${notebook_arg} --allow-root"
[ -n "${NOTEBOOK_DIR:+x}" ] && notebook_arg="${notebook_arg} --notebook-dir=${NOTEBOOK_DIR}"

exec jupyterhub-singleuser --ip=0.0.0.0 --port=8888 \
  --user=$JPY_USER \
  --cookie-name=$JPY_COOKIE_NAME \
  --base-url=$JPY_BASE_URL \
  --hub-prefix=$JPY_HUB_PREFIX \
  --hub-api-url=$JPY_HUB_API_URL \
  ${notebook_arg} \
  $@
