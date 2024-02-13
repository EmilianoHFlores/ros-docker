# Docker images and commands for ROS/ROS2 Development
This repository contains easy to use commands for generating custom docker images for ROS/ROS2. The images are not based from the official ROS/ROS2 images so as to allow for further customization, such as CUDA or L4T support. 

## Execution
### Starting Containers
Each ROS/ROS2 image has corresponding sudo Makefile commands for easy execution. First, run the build command:
```bash
sudo make <ros-distro>.build # No CUDA support
sudo make <ros-distro>.cuda.build # With CUDA support
```
Then, run the run command for creating the container:
```bash
sudo make <ros-distro>.create # No CUDA support
sudo make <ros-distro>.create.cuda # With CUDA support
```
Finally, run the start command for starting the container and entering the shell:
```bash
sudo make <ros-distro>.up # Start container
sudo make <ros-distro>.shell # Enter container terminal
```

### Deleting Containers
The sudo makefile containes further commands to delete containers:
```bash
sudo make <ros-distro>.down # Stop container
sudo make <ros-distro>.remove # Remove container
```

## Current Images

- [ROS Humble](./docker/Dockerfile.humble)
```bash
sudo make humble.build
sudo make humble.create
```
- [ROS Humble with CUDA11.8 and Pytorch 2.0](./docker/Dockerfile.humble.cuda)
```bash
sudo make humble.build.cuda
sudo make humble.create.cuda
```

## Docker container settings
The docker containers are set to use the host network and display, as well as devices such as webcam. It also mounts the projects folder for use ready-to-go use. On the run scripts at docker/scripts, these settings may be edited.