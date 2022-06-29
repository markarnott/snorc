<#
.SYNOPSIS
A helper script that installs podman in a WSL instance
The get-podman.sh script is written for ubuntu 
#>
param([string]$WslDistroName)

Push-Location $PSScriptRoot

If($null -eq $WslDistroName) {
    Import-Module .\WslUtilityFunctions.psm1

    $WslDistroName = Get-DefaultDistro
}

# convert line endings from Windows style to Unix style
(Get-Content -Raw ".\get-podman.sh") -Replace "`r`n","`n" | Set-Content -NoNewline ".\get-podman.sh"
wsl.exe -d $Distro -e ./get-podman.sh

Pop-Location

