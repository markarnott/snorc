# Convert a Docker Image to a WSL instance

## Step-by-Step Guide

This is a complete guide with all required steps listed for a clean Windows 10 machine.  You may be able to skip some step if they are already completed.

1. Verify that WSL is installed and the default version is 2  (only necessary on Windows 10)

```powershell
wsl.exe --status
```

2. Install Ubuntu if you don't already have it installed.

```powershell
wsl.exe --install --distribution Ubuntu-22.04
```

3. check to see if podman is installed (it will not be installed on a clean Ubuntu instance).

```powershell
$Distro = "Ubuntu-22.04"
wsl.exe -d $Distro -e podman --version
```

4. Install podman if it is not already installed

```powershell
.\shared\Install-Podman.ps1 -WslDistroName $Distro
``` 

5. If your container image comes from an Azure Container Registry, you will need the Az CLI to authenticate.

```powershell
.\shared\Install-AzCli.ps1 -WslDistroName $Distro
```

6. If required authenticate to your container registry.

7. Pull the container image, start the container and then export it.

```bash
podman pull $1
podman create --name snarky_snorc $1

podman export snarky_snorc > $2.tar
podman rm snarky_snorc
```
