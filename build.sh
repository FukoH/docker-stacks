#!/bin/bash

set -e

IMAGE_PREFIX="intelligencelab/datascience_"

function build_image(){
  TIMESTAMP=`date +%Y%m%d_%H%M%S`
  docker build -t $IMAGE_PREFIX$1:r$TIMESTAMP --force-rm=true --no-cache=true --compress --squash ./docker_$1
  docker tag $IMAGE_PREFIX$1:r$TIMESTAMP $IMAGE_PREFIX$1:latest
}

build_image ape
build_image base
