#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/start--pre.sh

notebook_arg=""

( ver_gte `jupyter notebook --version` 5.0.0 ) && notebook_arg="${notebook_arg} --allow-root"
[ -n "${USE_SSL:+x}" ] && notebook_arg="${notebook_arg} --NotebookApp.certfile=${NOTEBOOK_PEM_FILE}"


exec jupyter notebook ${notebook_arg} $*
