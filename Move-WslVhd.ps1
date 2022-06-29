<#
.SYNOPSIS
Move the virtual hard disk for a WSL V2 distribution to a new folder path
#>
param(
    [Parameter(Mandatory)][string]
    $DistroName,
    [Parameter(Mandatory)][string]
    $Destination
)

$ErrorActionPreference = "Stop"
Import-Module "$PSScriptRoot\shared\WslUtilityFunctions.psm1"

If(-Not(Test-Path $Destination)){
    New-Item -Path $Destination -ItemType Directory
}

If(Test-Path "$Destination\ext4.vhdx"){
    Write-Error "$Destination already contains a WLS virtual hard disk file (ext4.vhdx)"
    Exit
}

Stop-Distro -Name $DistroName

$RegKey = Find-DistroRegKey -DistroName $DistroName
If($null -eq $RegKey){
    Write-Error "Could not find Registry entries for $DistroName"
    Return
}

$BasePathValue = (Get-ItemProperty -Path $RegKey -Name "BasePath").BasePath

# For some unknown reason, WSL adds '\\?\' to the front of some base paths.
# So we strip that out here because it breaks the Move-Item command
$BasePathValue = $BasePathValue -replace "\\\\\?\\",""

If(-Not(Test-Path "$BasePathValue\ext4.vhdx")) {
    Write-Error "Could not find ext4.vhdx file at $BasePathValue"
    Exit
}

Move-Item -Path "$BasePathValue\ext4.vhdx" -Destination $Destination

Set-ItemProperty -Path $RegKey -Name "BasePath" -Value $Destination

Write-Host "Finished moving the $DistroName virtual drive from $BasePathValue to $Destination"