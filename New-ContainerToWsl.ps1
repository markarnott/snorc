<#
.SYNOPSIS
pull an image from a container registry and deploy it as a WSL distro
#>
param (
    [parameter(Mandatory=$true)]
    $Container,
    [parameter(Mandatory=$true)]
    $DistroName,
    $WslRootPath = "$ENV:USERPROFILE\WSL",
    [switch]$NoCleanup
)

#Verify that podman is installed and install it if it is not.
Function Test-Podman {
    $PodmanVer = wsl -e podman --version

    if($null -eq $PodmanVer){
        Write-Verbose "Installing Podman"
        wsl -e ./get-podman.sh
    }
    Write-Verbose "Found $PodmanVer"
}

Function New-WslDistro {
    param([string]$Container, [string]$WslRootPath, [string]$DistroName)

    $DistroPath = "$WslRootPath\$DistroName"

    if(-Not(Test-Path $DistroPath)) {
        New-Item $DistroPath -ItemType Directory
    }
    Push-Location $DistroPath
    
    # Jump thru hoops to convert line endings from Windows to Unix
    (Get-Content -Raw "$PSScriptRoot\boxcutter.sh") -Replace "`r`n","`n" | Set-Content -NoNewline .\boxcutter.sh

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