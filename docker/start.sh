#!/bin/bash

if [ $# != 1 ]; then
  echo "Usage: 
        bash start.sh [DATASETS_DIR]
       "
  exit 1
fi

get_real_path(){
  if [ "${1:0:1}" == "/" ]; then
    echo "$1"
  else
    realpath -m "$PWD"/"$1"
  fi
}

DATASETS_DIR=$(get_real_path "$1")

if [ ! -d $DATASETS_DIR ]
then
    echo "error: DATASETS_DIR=$DATASETS_DIR is not a directory."
exit 1
fi

ARCH=`uname -m`

orange=`tput setaf 3`
reset_color=`tput sgr0`

BASE_PATH=$(cd ./"`dirname $0`" || exit; pwd)
cd $BASE_PATH

echo "Running on ${orange}${ARCH}${reset_color}"

if [ "$ARCH" == "x86_64" ] 
then
    ARGS="--ipc host --gpus all -e NVIDIA_DRIVER_CAPABILITIES=all"
else
    echo "Arch ${ARCH} not supported"
    exit
fi

docker run -it -d --rm \
    $ARGS \
    --privileged \
    --name ${USER}_minklocmultimodal \
    --net host \
    -v $BASE_PATH/../:/home/docker_minklocmultimodal/MinkLocMultimodal:rw \
    -v $DATASETS_DIR/:/home/docker_minklocmultimodal/Datasets:rw \
    minklocmultimodal

docker exec --user root \
    ${USER}_minklocmultimodal bash -c "/etc/init.d/ssh start"