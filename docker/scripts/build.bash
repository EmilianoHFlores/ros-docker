#!/bin/bash
# Use Dockerfile according to NVIDIA GPU and CUDA availability

# Receive ROS version from command line, through the --ros-distro argument
CUDA_IMAGE="runtime" # default to runtime -> smaller image size
for i in "$@"
do
case $i in
    --ros-distro=*)
    ROS_DISTRO="${i#*=}"
    shift # past argument=value
    ;;
    --use-cuda)
    USE_CUDA=YES
    shift # past argument with no value
    ;;
    # Receive the --cuda-devel argument, to use devel images
    --cuda-image=*)
    CUDA_IMAGE_ARG="${i#*=}"
    # if cuda image not runtime, devel or base, return error
    if [ "$CUDA_IMAGE_ARG" != "runtime" ] && [ "$CUDA_IMAGE_ARG" != "devel" ] && [ "$CUDA_IMAGE_ARG" != "base" ] && [ "$CUDA_IMAGE_ARG" != "cudnn8-devel" ] && [ "$CUDA_IMAGE_ARG" != "cudnn8-runtime" ]; then
        # echo list of possible values, include cudnn8-devel
        echo "CUDA image must be: runtime, devel, base, cudnn8-devel, cudnn8-runtime"
        exit 1
    fi
    if [ -n CUDA_IMAGE_ARG ]; then
        CUDA_IMAGE=$CUDA_IMAGE_ARG
    fi
    shift # past argument with no value
    ;;
    --l4t=*)
    # if l4t is not empty, set the l4t version
    if [ -n "${i#*=}" ]; then
        L4T_VERSION="${i#*=}"
    fi
    shift # past argument=value
    ;;
    *)
          # unknown option
    ;;
esac
done

# if ros-distro not set, return error
if [ -z "$ROS_DISTRO" ]; then
    echo "ROS distro not set. Use --ros-distro=distro"
    exit 1
fi

DOCKER_FILE="$PWD/docker/Dockerfile.${ROS_DISTRO}"
IMAGE_NAME="emilianh/ros:$ROS_DISTRO"
echo "Building for docker distro: $ROS_DISTRO"

if [ -n "$USE_CUDA" ]; then
    DOCKER_FILE="$PWD/docker/Dockerfile.${ROS_DISTRO}.cuda"
    IMAGE_NAME="emilianh/ros:$ROS_DISTRO-cuda"
    echo "Using CUDA"
fi

if [ -n "$L4T_VERSION" ]; then
    DOCKER_FILE="$PWD/docker/Dockerfile.${ROS_DISTRO}.l4t${L4T_VERSION}"
    IMAGE_NAME="emilianh/ros:$ROS_DISTRO-l4t${L4T_VERSION}"
    echo "Using L4T $L4T_VERSION"
fi

USER_UID=$(id -u)
USER_GID=$(id -g)
echo "User UID: $USER_UID"
echo "User GID: $USER_GID"
echo "Building image: $IMAGE_NAME"
echo "Using Dockerfile: $DOCKER_FILE"

docker build -t $IMAGE_NAME \
    -f $DOCKER_FILE $PWD --build-arg USER_UID=$USER_UID --build-arg USER_GID=$USER_GID --build-arg CUDA_IMAGE=$CUDA_IMAGE