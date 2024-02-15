# ----------------------------------------------------------------------
#  ROS-Humble Docker Development
# ----------------------------------------------------------------------

#: Builds a Docker image with the corresponding Dockerfile file

# ---------HUMBLE----------
# No GPU
humble.build:
	@./docker/scripts/build.bash --ros-distro=humble

# CUDA 11.8 x86_64
humble.build.cuda:
	@./docker/scripts/build.bash --ros-distro=humble --use-cuda

# ---------NOETIC----------

noetic.build:
	@./docker/scripts/build.bash --ros-distro=noetic

noetic.build.cuda:
	@./docker/scripts/build.bash --ros-distro=noetic --use-cuda

# Create containers
humble.create:
	@./docker/scripts/run.bash --ros-distro=humble

# Create containers with CUDA support
humble.create.cuda:
	@./docker/scripts/run.bash --ros-distro=humble --use-cuda

noetic.create:
	@./docker/scripts/run.bash --ros-distro=noetic

noetic.create.cuda:
	@./docker/scripts/run.bash --ros-distro=noetic --use-cuda

# Start containers
humble.up:
	@xhost +
	@docker start ros-humble 

noetic.up:
	@xhost +
	@docker start ros-noetic

# Stop containers
humble.down:
	@docker stop ros-humble 

noetic.down:
	@docker stop ros-noetic

# Restart containers
humble.restart:
	@docker restart ros-humble 

noetic.restart:
	@docker restart ros-noetic

# Logs of the container
humble.logs:
	@docker logs --tail 50 ros-humble 

noetic.logs:
	@docker logs --tail 50 ros-noetic

# Fires up a bash session inside the container
humble.shell:
	@docker exec -it --user $(shell id -u):$(shell id -g) ros-humble bash

noetic.shell:
	@docker exec -it --user $(shell id -u):$(shell id -g) ros-noetic bash

# Remove container
humble.remove:
	@docker container rm ros-humble 

noetic.remove:
	@docker container rm ros-noetic

# ----------------------------------------------------------------------
#  General Docker Utilities

#: Show a list of images.
list-images:
	@docker image ls

#: Show a list of containers.
list-containers:
	@docker container ls -a