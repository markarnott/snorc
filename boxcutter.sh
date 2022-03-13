#!/bin/bash

# use podman to pull a container and then squash it for import into wsl
# usage: $1 is the image path to pull. $2 is the tar file name

podman pull $1
podman create --name snarky_snorc $1

podman export snarky_snorc > $2.tar
podman rm snarky_snorc

