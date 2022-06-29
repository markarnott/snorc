<#
.SYNOPSIS
pull an image from a container registry and deploy it as a WSL distro

.PARAMETER Container
The docker path of the container that will be pulled and then converted

.PARAMETER NewDistroName
The name of the WSL Distro that this script will create

.PARAMETER WslRootPath
(Optional) The folder path where the distro's virtual hard drive will be saved.

.PARAMETER BootstrapDistroName
(Optional) An existing WSL distro that is used to run podman to pull and convert the container image.  
This distro must be a version of Ubuntu.  
If this parameter is not supplied the script will probe to find an ubuntu distribution.

.NOTES
TODO if the default distro is not ubuntu, podman install will go haywire.
We need to probe the installed distros looking for ubuntu.
#>
param (
    [parameter(Mandatory)]
    $Container,
    [parameter(Mandatory)]
    $NewDistroName,
    $BootstrapDistroName,
    $WslRootPath = "$ENV:USERPROFILE\WSL",
    [switch]$NoCleanup
)

Write-Warning "DEPRECATED:  This script is too brittle.  It will be removed soon"

Import-Module "$PSScriptRoot\shared\WslUtilityFunctions.psm1"

Function Main{

    If($null -eq $BootstrapDistroName){
        $BootstrapDistroName = Find-DistroFromLinuxFamily "ubuntu"
    }
    
    New-WslDistro -Container $Container -WslRootPath $WslRootPath -DistroName $DistroName
    
}

Function New-WslDistro {
    param([string]$Container, [string]$WslRootPath, [string]$DistroName)

    $DistroPath = "$WslRootPath\$DistroName"

    if(-Not(Test-Path $DistroPath)) {
        New-Item $DistroPath -ItemType Directory
    }
    Push-Location $DistroPath
    
    # convert line endings from Windows to Unix
    (Get-Content -Raw "$PSScriptRoot\shared\boxcutter.sh") -Replace "`r`n","`n" | Set-Content -NoNewline ".\boxcutter.sh"

    wsl -e ./boxcutter.sh $Container $DistroName

    wsl --import $DistroName . "$DistroName.tar"

    if(-Not $NoCleanup) {
        Remove-Item "$DistroName.tar"
        Remove-Item "boxcutter.sh"
    }

    Pop-Location
}

Main

wsl.exe --list -v