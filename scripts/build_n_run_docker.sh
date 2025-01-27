#!/bin/bash

set -e
set -x  

# Give Docker access to the X server
xhost +local:docker
IMAGE_NAME="spaghettos"

# Build Docker image
docker build -t $IMAGE_NAME .

# Run the Docker container
docker run -e DISPLAY=$DISPLAY \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           $IMAGE_NAME