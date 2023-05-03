<#  
    .SYNOPSIS
    Copy the registry values named DefaultEnvironment, DefaultUid and KernelCommandLine from one 
    Distribution's Registry Key to another Distribution's Registry Key
#>
Function Copy-DistroSettings{
    param([string]$FromDistro, [string]$ToDistro)

    $OldDistroRegKey = Find-DistroRegKey -DistroName $FromDistro
    If($null -eq $OldDistroRegKey){
        Write-Error "Could not find Registry entries for $FromDistro"
        Return
    }

    $NewDistroRegKey = Find-DistroRegKey -DistroName $ToDistro
    If($null -eq $NewDistroRegKey){
        Write-Error "Could not find Registry entries for $ToDistro"
        Return
    }
    Copy-RegKeyValue -FromKey $OldDistroRegKey -ToKey $NewDistroRegKey -ValueName "DefaultEnvironment"
    Copy-RegKeyValue -FromKey $OldDistroRegKey -ToKey $NewDistroRegKey -ValueName "DefaultUid"
    Copy-RegKeyValue -FromKey $OldDistroRegKey -ToKey $NewDistroRegKey -ValueName "KernelCommandLine"
}