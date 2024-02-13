#!/bin/bash
# Use Dockerfile according to NVIDIA GPU and CUDA availability
DOCKER_FILE="$PWD/docker/Dockerfile.humble"

if [[ "$@" == *"--use-cuda"* ]]; then
    DOCKER_FILE="$PWD/docker/Dockerfile.humble.cuda"
    echo "Using Dockerfile for NVIDIA GPU"
fi

echo $DOCKER_FILE

docker build -t ros2-humble \
    -f $DOCKER_FILE $PWD