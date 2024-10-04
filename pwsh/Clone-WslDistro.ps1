<#
.SYNOPSIS
Clone an existing local WSL Distro into a new instance

.DESCRIPTION

.PARAMETER NewDistroName
The name of the new cloned WSL distribution that will be created.

.PARAMETER OldDistroName
(Optional) The name of the existing WSL distribution that will get cloned.  
If this parameter is not specified, the default distribution will get cloned.

.PARAMETER WslRootPath
This parameter determines where the WSL distributions virtual hard disk will be store.
This defaults to a folder named 'WSL' in the users profile.
#>
param(
    [Parameter(Mandatory)][string]
    $NewDistroName,
    [string]
    $OldDistroName,
    $WslRootPath = "$ENV:USERPROFILE\WSL"
)

Import-Module "$PSScriptRoot\module\Posh-Wsl.psm1"

Function Main{

    If($OldDistroName.Length -eq 0){
        $OldDistroName = Get-DefaultDistro
    }

    $NewDistroPath = Join-Path $WslRootPath -ChildPath $NewDistroName
    If(-Not(Test-Path $NewDistroPath)){
        New-Item -Path $NewDistroPath -ItemType Directory | Out-Null
    }

    If(Test-Path "$NewDistroPath\ext4.vhdx"){
        Write-Error "$NewDistroPath already contains a WLS virtual hard disk file (ext4.vhdx)"
        Exit
    }

    Stop-Distro -Name $OldDistroName

    Clone-Distro -From $OldDistroName -To $NewDistroName -WslDistroPath $NewDistroPath

    Copy-DistroSettings -FromDistro $OldDistroName -ToDistro $NewDistroName

    #TODO check for errors and warn
    Write-Host "Cloning From $OldDistroName To $NewDistroName is complete"
}


Function Clone-Distro{
    param([string]$From, [string]$To, [string]$WslDistroPath)

    Write-Host "Cloning From $From To $To."
    $TimeStamp = Get-Date -Format "yyyy-MM-dd"
    $BackupFilePath = Join-Path $WslDistroPath -ChildPath "$TimeStamp.Export.$From.tar.gz"
    wsl.exe --export $From $BackupFilePath
    Write-Verbose "Export to $BackupFilePath complete"

    wsl.exe --import $To $WslDistroPath $BackupFilePath
    Write-Verbose "Import to $WslDistroPath complete"
    Write-Verbose "Removing export tar file $BackupFilePath"
    Remove-Item $BackupFilePath
}

Main