# Simply NO Requirement for Containers

SNORC is a few scripts that will convert a container into a WSL distribution

## Overview

Containers are great but sometimes they bring more complexity than needed.

These scripts pull an image from a container registry and deploy it as a WSL distro 

## Usage

>.\New-ContainerToWsl.ps1 -Container "busybox:stable" -DistroName "BusyBox"

## Prerequisites.

Windows Subsystem for Linux, WSL must be enabled

An Ubuntu distribution must be installed on WSL.