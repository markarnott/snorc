# Simply NO Requirement for Containers

SNORC is a few scripts that will convert a container into a WSL distribution

## Overview

Do you love working in isolated development environments with Windows Subsystem for Linux, WSL.

Do you love the ease of pulling down your development tools from a container registry.

Do you hate the complexity of Docker and Kubernetes and all the other container hoopla getting in the way of your productivity.

Containers are great but sometimes they bring more complexity than needed.
These scripts pull an image from a container registry and deploy it as a WSL distro.

## Usage

>.\New-ContainerToWsl.ps1 -Container "busybox:stable" -DistroName "BusyBox"

## Prerequisites

WSL must be enabled.

An Ubuntu distribution must be installed on WSL.

## Warning

SNORC works with simple containers.

WSL is not compatible with Linux Systemd.  If the container includes systemd it will not work when converted to a WSL distro.
