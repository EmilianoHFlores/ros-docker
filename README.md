# Docker images and commands for ROS/ROS2 Development
This repository contains easy to use commands for generating custom docker images for ROS/ROS2. The images are not based from the official ROS/ROS2 images so as to allow for further customization, such as CUDA or L4T support. 

## Prerequisites
### Docker engine installation
First, install the docker engine on your host machine. The installation instructions can be found [here](https://docs.docker.com/engine/install/).
Warning: On Ubuntu, install docker desktop at own risk. It may cause issues with the host machine's network settings given it uses a virtual machine with its own network configuration.

### Docker group
Add your user to the docker group to avoid using sudo for docker commands:
```bash
sudo usermod -aG docker $USER
```
Then, log out and log back in so that your group membership is re-evaluated.

### NVIDIA Container Toolkit
If you are using a GPU, install the NVIDIA Container Toolkit. The installation instructions can be found [here](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).

### Cloning the repository
Clone the repository to your local machine:
```bash
git clone https://github.com/EmilianoHFlores/ros-docker
cd ros-docker
```

## Execution
### Starting Containers

Each ROS/ROS2 image has corresponding Makefile commands for easy execution. First, start at repo directory and run the build command:
```bash
cd ros-docker
make <ros-distro>.build # No CUDA support
make <ros-distro>.build.cuda # With CUDA support
```
Then, run the run command for creating the container:
```bash
make <ros-distro>.create # No CUDA support
make <ros-distro>.create.cuda # With CUDA support
```
Finally, run the start command for starting the container and entering the shell:
```bash
make <ros-distro>.up # Start container
make <ros-distro>.shell # Enter container terminal
```

### Deleting Containers
The makefile containes further commands to delete containers:
```bash
make <ros-distro>.down # Stop container
make <ros-distro>.remove # Remove container
```

## Current Images

- [ROS Noetic](./docker/Dockerfile.noetic)
```bash
make noetic.build
make noetic.create
```

- [ROS Noetic with CUDA11.8](./docker/Dockerfile.noetic.cuda)
```bash
make noetic.build.cuda
make noetic.create.cuda
```

- [ROS Humble](./docker/Dockerfile.humble)
```bash
make humble.build
make humble.create
```
- [ROS Humble with CUDA11.8](./docker/Dockerfile.humble.cuda)
```bash
make humble.build.cuda
make humble.create.cuda
```

## Mounting Directories
The docker run commands mount selected folders for easy access to the host machine files. Files to mount are called as arguments to the make commands. For example, to mount a directory "ros-workspace" in the repository folder to the container, run the following command:
```bash
make <distro>.create volumes="ros-workspace"
```
Similarly, to mount multiple directories, separate them with a comma:
```bash
make <distro>.create volumes="ros-workspace,~/other-folder,/home/user/Documents/another-folder"
```
Any folder mounted from the host machine will be available in the container at the /workspace directory, where the container starts.

## Additional Options
### Editing container name
Default names for containers are "ros-<distro>". This name is shared between cuda and non-cuda containers. When creating the name of the container may be edited by setting the "name" variable:
```bash
make <distro>.create name="my-container" # no volume
make <distro>.create name="my-container" volumes="ros-workspace" # with volume
```
Consider that docker commands on this container must be run manually, including exec, stop, and remove commands. Remember to include user on docker exec:
```bash
docker exec -it --user $(shell id -u):$(shell id -g) my-container bash
```

## Docker container settings
The docker containers are set to use the host network and display, as well as devices such as the webcam. On the run scripts at docker/scripts, these settings may be edited.