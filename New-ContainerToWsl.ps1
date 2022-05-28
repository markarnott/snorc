<#
.SYNOPSIS
pull an image from a container registry and deploy it as a WSL distro

.PARAMETER Container
The name of the container that will be pulled and then converted

.PARAMETER NewDistroName
The name of the WSL Distro that this script will create

.PARAMETER WslRootPath
(Optional) The folder path where the distro's virtual hard drive will be saved.

.PARAMETER BootstrapDistroName
(Optional) An existing WSL distro that is used to run podman to pull and convert the container image.  
This distro should be a version of Ubuntu (Debian might work, but has not been tested.)

.NOTES
TODO if the default distro is not ubuntu, podman install will go haywire.
We need to probe the installed distros looking for ubuntu.
#>
param (
    [parameter(Mandatory)]
    $Container,
    [parameter(Mandatory)]
    $NewDistroName,
    $BootstrapDistroName = "Ubuntu-20.04",
    $WslRootPath = "$ENV:USERPROFILE\WSL",
    [switch]$NoCleanup
)

#Verify that podman is installed and install it if it is not.
Function Test-Podman {
    $PodmanVer = wsl -e podman --version

    if($null -eq $PodmanVer){
        Write-Verbose "Installing Podman"
        
        # convert line endings from Windows to Unix
        (Get-Content -Raw ".\get-podman.sh") -Replace "`r`n","`n" | Set-Content -NoNewline ".\get-podman.sh"
        wsl -e ./get-podman.sh
    }
    Write-Verbose "Found $PodmanVer"
}

Function Test-Distros {
#TODO
}

Function New-WslDistro {
    param([string]$Container, [string]$WslRootPath, [string]$DistroName)

    $DistroPath = "$WslRootPath\$DistroName"

    if(-Not(Test-Path $DistroPath)) {
        New-Item $DistroPath -ItemType Directory
    }
    Push-Location $DistroPath
    
    # convert line endings from Windows to Unix
    (Get-Content -Raw "$PSScriptRoot\boxcutter.sh") -Replace "`r`n","`n" | Set-Content -NoNewline ".\boxcutter.sh"

    wsl -e ./boxcutter.sh $Container $DistroName

    wsl --import $DistroName . "$DistroName.tar"

    if(-Not $NoCleanup) {
        Remove-Item "$DistroName.tar"
        Remove-Item "boxcutter.sh"
    }

    Pop-Location
}

Test-Podman

New-WslDistro -Container $Container -WslRootPath $WslRootPath -DistroName $DistroName

wsl --list -v