#!/bin/bash

# Thanks to https://www.atlantic.net/dedicated-server-hosting/how-to-install-and-use-podman-on-ubuntu-20-04
sudo apt-get update -y

source /etc/os-release
#TODO warn if not Ubuntu

sudo apt-get install curl wget gnupg2 -y

suseDevelRoot="http://download.opensuse.org/repositories/devel:"
sudo sh -c "echo 'deb ${suseDevelRoot}/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list"

sudo wget -nv ${suseDevelRoot}kubic:libcontainers:stable/xUbuntu_${VERSION_ID}/Release.key -O- | sudo apt-key add -

sudo apt-get update -qq -y
sudo apt-get -qq --yes install podman

podman --version

podman info
