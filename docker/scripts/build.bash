#!/bin/bash
# Use Dockerfile according to NVIDIA GPU and CUDA availability

# Receive ROS version from command line, through the --ros-distro argument
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
    # Receive the --cuda-image argument, to specify CUDA image type
    --cuda-image=*)
    CUDA_IMAGE="${i#*=}"
    # default if empty
    if [ -z $CUDA_IMAGE ]; then
        echo "Defaulting to CUDA image: runtime"
        CUDA_IMAGE="runtime"
    # if cuda image not runtime, devel or base, return error
    elif [ "$CUDA_IMAGE" != "runtime" ] && [ "$CUDA_IMAGE" != "devel" ] && [ "$CUDA_IMAGE" != "base" ] && [ "$CUDA_IMAGE" != "cudnn8-devel" ] && [ "$CUDA_IMAGE" != "cudnn8-runtime" ]; then
        # echo list of possible values, include cudnn8-devel
        echo "You can specify CUDA image version as : runtime, devel, base, cudnn8-devel, cudnn8-runtime"
        exit 0
    fi
    shift # past argument with no value
    ;;
    # Receive the --cuda-version argument, to specify CUDA version. Allow 11.8 and 12.1, default to 11.8
    --cuda-version=*)
    CUDA_VERSION="${i#*=}"
    # if cuda version not 11.8 or 12.1, return error
    if [ -z $CUDA_VERSION ]; then
        echo "Defaulting to CUDA version: 11.8"
        CUDA_VERSION="11.8"
    elif [ "$CUDA_VERSION" != "11.8" ] && [ "$CUDA_VERSION" != "12.1" ]; then
        # echo list of possible values
        echo "You can specify CUDA version as : 11.8, 12.1"
        exit 0
    fi
    shift # past argument=value
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


CUDA_IMAGE="${CUDA_VERSION}.0-${CUDA_IMAGE}"

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
    echo "CUDA Docker image: $CUDA_IMAGE"
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