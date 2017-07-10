#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/start--pre.sh

notebook_arg=""
( vergte `jupyter notebook --version` 5.0.0 ) && notebook_arg="${notebook_arg} --allow-root"

exec jupyter lab ${notebook_arg} $*
