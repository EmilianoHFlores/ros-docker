# ----------------------------------------------------------------------
#  ROS2-Humble Docker Development
# ----------------------------------------------------------------------

#: Builds a Docker image with the corresponding Dockerfile file
# No GPU
humble.build:
	@./docker/scripts/build.humble.bash

# CUDA 11.8 x86_64
humble.build.cuda:
	@./docker/scripts/build.humble.bash --use-cuda

# Create containers
humble.create:
	@./docker/scripts/run.humble.bash

# Create containers with CUDA support
humble.create.cuda:
	@./docker/scripts/run.humble.bash --use-cuda

# Start containers
humble.up:
	@xhost +
	@docker start ros2-humble 

# Stop containers
humble.down:
	@docker stop ros2-humble 

# Restart containers
humble.restart:
	@docker restart ros2-humble 

# Logs of the container
humble.logs:
	@docker logs --tail 50 ros2-humble 

# Fires up a bash session inside the container
humble.shell:
	@docker exec -it --user $(shell id -u):$(shell id -g) ros2-humble bash

# Remove container
humble.remove:
	@docker container rm ros2-humble 

# ----------------------------------------------------------------------
#  General Docker Utilities

#: Show a list of images.
list-images:
	@docker image ls

#: Show a list of containers.
list-containers:
	@docker container ls -a