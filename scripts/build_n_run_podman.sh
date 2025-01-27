#!/bin/bash

set -e
set -x  

# Give Podman access to the X server
xhost +local:podman
IMAGE_NAME="spaghettos"

# Build Podman image
podman build -t $IMAGE_NAME .

# Run the Podman container
podman run -e DISPLAY=$DISPLAY \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           $IMAGE_NAME