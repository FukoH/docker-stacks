#!/bin/bash
source start--pre.sh

notebook_arg=""
( vergte `jupyter notebook --version` 5.0.0 ) && notebook_arg="${notebook_arg} --allow-root"

exec jupyter lab ${notebook_arg} $*
