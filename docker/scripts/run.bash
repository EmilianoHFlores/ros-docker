#!/bin/bash

# Variables required for logging as a user with the same id as the user running this script
export LOCAL_USER_ID=`id -u $USER`
export LOCAL_GROUP_ID=`id -g $USER`
export LOCAL_GROUP_NAME=`id -gn $USER`
DOCKER_USER_ARGS="--env LOCAL_USER_ID --env LOCAL_GROUP_ID --env LOCAL_GROUP_NAME"

# Variables for forwarding ssh agent into docker container
SSH_AUTH_ARGS=""
if [ ! -z $SSH_AUTH_SOCK ]; then
    DOCKER_SSH_AUTH_ARGS="-v $(dirname $SSH_AUTH_SOCK):$(dirname $SSH_AUTH_SOCK) -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK"
fi

DOCKER_NETWORK_ARGS="--net host"
if [[ "$@" == *"--net "* ]]; then
    DOCKER_NETWORK_ARGS=""
fi

# Receive ROS version from command line, through the --ros-distro argument
for i in "$@"
do
case $i in
    --ros-distro=*)
    ROS_DISTRO="${i#*=}"
    echo "ROS distro set to: $ROS_DISTRO"
    shift # past argument=value
    ;;
    --use-cuda)
    USE_CUDA=YES
    shift # past argument with no value
    ;;
    *)
          # unknown option
    ;;
esac
done

# CHECK IF argument USE_CUDA is passed
DOCKER_GPU_ARGS=""
if [ -n "$USE_CUDA" ]; then
    DOCKER_GPU_ARGS="--gpus all"
    echo "Using CUDA"
fi

DOCKER_COMMAND="docker run"

IMAGE_NAME="ros-$ROS_DISTRO"

xhost +
$DOCKER_COMMAND -it -d\
    $DOCKER_USER_ARGS \
    $DOCKER_GPU_ARGS \
    $DOCKER_SSH_AUTH_ARGS \
    $DOCKER_NETWORK_ARGS \
    $ADDITIONAL_COMMANDS \
    --privileged \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /dev:/dev \
    --device /dev/video0:/dev/video0 \
    -v "$PWD/projects:/projects" \
    -w /projects \
    --name=$IMAGE_NAME \
    $IMAGE_NAME \
    bash