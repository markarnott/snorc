# Convert a Docker Image to a WSL instance

## High-level Tool Agnostic Steps

1. Pull a container image
    1. `docker pull {image}`
    1. Your choice of container technology could be Docker, Podman, Rancher
    1. Your container image could be in Docker Hub, Azure ACR, or Amazon ECR
1. Start the container
    1. `docker create --name {container-name} {image}`
1. Export the container to a tar file
    1. `docker export {container-name} > /mnt/c/export.tar`
1. Import the tar file into WSL
    1. `wsl.exe --import {InstanceName} {InstallLocation} C:\export.tar`
1. Configure the WSL instance

## Opinionated Step-by-Step Guide

This is a complete, opinionated guide listing all required steps for a clean Windows 10 machine.
It uses podman to pull and create the container image.
If you are on Windows 11 or have Docker installed, you may be able to skip some steps or use alternate methods.

#### 1) Verify that WSL is installed and the default version is 2

(only necessary on Windows 10)

```powershell
wsl.exe --status

wsl.exe --list
```

#### 2) Install Ubuntu on Windows 

(if you don't already have it installed.)

```powershell
wsl.exe --install --distribution Ubuntu-22.04
```

#### 3) Check to see if podman is installed

(it will not be installed on a clean Ubuntu instance).

```powershell
$Distro = "Ubuntu-22.04"
wsl.exe -d $Distro -e podman --version
```

#### 4) Install podman

(if it is not already installed)

The included `Install-Podman` powershell script automates the installation process

```powershell
.\shared\Install-Podman.ps1 -WslDistroName $Distro
```

#### 5) If required authenticate to your container registry

These steps apply to the Azure Container Registry, other registry authentication processes are different.

You will need the Az CLI installed on Windows to authenticate.
[How to Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)

```powershell
$RegistryName = "YourRegistry"

az login
$AcrCreds = az acr login --name $RegistryName --expose-token | ConvertFrom-Json
wsl.exe -d $Distro -e podman login $AcrCreds.loginServer -u 00000000-0000-0000-0000-000000000000 -p $AcrCreds.accessToken
```

#### 6) Launch the wsl instance

```powershell
wsl.exe -d $Distro
```

Steps 7 and 8 must be executed on your Ubuntu session.

#### 7) Pull the container image and create the container

```bash
cimage={your-container-image-name}
podman pull $cimage
podman create --name snarky_snorc $cimage
```

#### 8) Export the container to a tar file on the windows file system

```bash
cd /mnt/c/
podman export snarky_snorc > ./container_export.tar
```

#### 9) Import the tar file into a new WSL instance

These command are run from powershell on Windows.
Set the $DistroName variable to something that makes sense to you.

```powershell
$DistroName = "YouChooseAName"
$DistroPath = "$ENV:UserProfile\WSL\$DistroName\"

New-Item $DistroPath -ItemType Directory

Push-Location $DistroPath
wsl --import $DistroName . "C:\container_export.tar"
Pop-Location
```

#### 10) Configure new WSL distribution environment and user

Your distro will start with sessions running as root.  That is a bad security practice.

::TODO Document how to create a user
::    Or better yet figure out how (if possible) to copy the default user from the Ubuntu distro

#### 11) (Optionally) Cleanup tar file and container instance

On Windows
```powershell
Remove-Item "C:\container_export.tar"
```

On Ubuntu
```bash
podman rm snarky_snorc
```
