<#
.SYNOPSIS
This is now obsolete.  Podman has a native windows package.

.DESCRIPTION
A helper script that installs podman in a WSL instance
The get-podman.sh script is written for ubuntu 22.04
#>
param(
    [string]$WslDistroName
)

Push-Location $PSScriptRoot

# git's autocrlf=true screws up line endings.  Take precaution and convert line endings from Windows style to Unix style
(Get-Content -Raw ".\get-podman.sh") -Replace "`r`n","`n" | Set-Content -NoNewline ".\get-podman.sh"

wsl.exe -d $Distro -e ./get-podman.sh

Pop-Location

