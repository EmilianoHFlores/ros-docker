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
echo "Building for docker distro: $ROS_DISTRO"

if [ -n "$USE_CUDA" ]; then
    DOCKER_FILE="$PWD/docker/Dockerfile.${ROS_DISTRO}.cuda"
    echo "Using CUDA"
fi

echo $DOCKER_FILE

docker build -t ros-$ROS_DISTRO \
    -f $DOCKER_FILE $PWD