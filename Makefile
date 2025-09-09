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
	@./docker/scripts/build.bash --ros-distro=humble --use-cuda --cuda-image=$(cuda-image) --cuda-version=$(cuda-version)

# Jetson L4T 35.2.1
humble.build.jetson.35.2.1:
	@./docker/scripts/build.bash --ros-distro=humble --l4t=35.2.1 

# ---------NOETIC----------

noetic.build:
	@./docker/scripts/build.bash --ros-distro=noetic

noetic.build.cuda:
	@ ./docker/scripts/build.bash --ros-distro=noetic --use-cuda --cuda-image=$(cuda-image) --cuda-version=$(cuda-version)


# ----------------------------CREATE------------------------------------

# Create containers, receive arguments --volume
humble.create:
	@./docker/scripts/run.bash --ros-distro=humble --volumes=$(volumes) --name=$(name)

# Create containers with CUDA support
humble.create.cuda:
	@./docker/scripts/run.bash --ros-distro=humble --use-cuda --volumes=$(volumes) --name=$(name)

humble.create.jetson.35.2.1:
	@./docker/scripts/run.bash --ros-distro=humble --l4t=35.2.1 --volumes=$(volumes) --name=$(name)

# Create containers with Noetic
noetic.create:
	@./docker/scripts/run.bash --ros-distro=noetic --volumes=$(volumes) --name=$(name)

noetic.create.cuda:  
	@./docker/scripts/run.bash --ros-distro=noetic --use-cuda --volumes=$(volumes) --name=$(name) 

# ----------------------------START------------------------------------
# Start containers
humble.up:
	@ if [ -n "$(DISPLAY)" ]; then xhost +; fi
	@docker start ros-humble-$(USER)

noetic.up:
	@ if [ -n "$(DISPLAY)" ]; then xhost +; fi
	@docker start ros-noetic-$(USER)

# ----------------------------STOP------------------------------------
# Stop containers
humble.down:
	@docker stop ros-humble-$(USER)

noetic.down:
	@docker stop ros-noetic-$(USER)

# ----------------------------RESTART------------------------------------
# Restart containers
humble.restart:
	@docker restart ros-humble-$(USER)

noetic.restart:
	@docker restart ros-noetic-$(USER)

# ----------------------------LOGS------------------------------------
# Logs of the container
humble.logs:
	@docker logs --tail 50 ros-humble-$(USER)

noetic.logs:
	@docker logs --tail 50 ros-noetic-$(USER)

# ----------------------------SHELL------------------------------------
# Fires up a bash session inside the container
humble.shell:
	@docker exec -it --user $(shell id -u):$(shell id -g) ros-humble-$(USER) bash

noetic.shell:
	@docker exec -it --user $(shell id -u):$(shell id -g) ros-noetic-$(USER) bash

# ----------------------------REMOVE------------------------------------
# Remove container
humble.remove:
	@docker container rm ros-humble-$(USER)

noetic.remove:
	@docker container rm ros-noetic-$(USER)

# ----------------------------------------------------------------------
#  General Docker Utilities

#: Show a list of images.
list-images:
	@docker image ls

#: Show a list of containers.
list-containers:
	@docker container ls -a