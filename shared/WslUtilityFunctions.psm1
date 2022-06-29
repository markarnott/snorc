Function Stop-Distro{
<# .SYNOPSIS
    check to see if a distribution is running and call the wsl --terminate command if it is
#>
    param([string]$Name)

    $RunningDistros = Get-Distros -Running
    If($RunningDistros -contains $Name){
        Write-Host "Stopping the $Name distro" 
        wsl.exe --terminate $Name

        # WSL returns before the shutdown is complete and this can cause issues.  So pause to be safe.
        Start-Sleep -Seconds 2
        Write-Host "The $Name distro has been terminated" 
    } Else {
        Write-Verbose "The $Name distro was not running"
    }

}


Function Get-Distros{
<# .SYNOPSIS
    Return an array of the names of the installed wsl distributions.
#>
    param([switch]$Running)

    # Deal with wsl.exe weird UTF16 console output.
    $prev = [Console]::OutputEncoding; 
    [Console]::OutputEncoding = [System.Text.Encoding]::Unicode

    If($Running){
        # Only return the names of the running distros
        $WslOut = wsl.exe --list --running
    } Else {
        # return the names of all the distros
        $WslOut = wsl.exe --list
    }
    [Console]::OutputEncoding = $prev

    #Remove empty lines and the first 'banner' line
    $DistroNames = $WslOut | Where-Object { $_ -ne "" } | Select-Object -Skip 1

    #Remove the (Default) indicator
    For($idx=0; $idx -lt $DistroNames.Length; $idx++){
        If($DistroNames[$idx] -match "(Default)"){
            $DistroNames[$idx] = $DistroNames[$idx] -replace " \(Default\)", ""
        }
    }

    Return $DistroNames
}

Function Get-DefaultDistro{
<# .SYNOPSIS
    Return the name of the default wsl distribution
#>
    $DefaultDistroId = (Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss\").DefaultDistribution
    $DefaultDistroName = (Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss\$DefaultDistroId").DistributionName
    Return $DefaultDistroName
}

Function Find-DistroFromLinuxFamily{
<# .SYNOPSIS
    Probe the WSL instances to find a type of linux

    .NOTES 
    We use the /etc/os-release data from a WSL instance to figure out what kind of linux it is.  
    We need an ubuntu instance for the get-podman.sh installer
#>
    param([string]$LinuxFamilyId = "ubuntu")

    # First see if the default distro is from the Linux 'Family' specifid
    $Default = Get-DefaultDistro 

    $OsReleaseInfo = (wsl -d $Default cat /etc/os-release) | ConvertFrom-StringData

    If($OsReleaseInfo.ID -like $LinuxFamilyId) {
        return $Default
    }

    # If we got here the default distro was not from the Linux 'Family' specified
    # So we look thru all the distros and return the first match.
    $AllDistros = Get-Distros
    ForEach($Distro in $AllDistros){
        $OsReleaseInfo = (wsl -d $Distro cat /etc/os-release) | ConvertFrom-StringData

        If($OsReleaseInfo.ID -like $LinuxFamilyId) {
            return $Distro
        }       
    }
}

Function Copy-DistroSettings{
<#  .SYNOPSIS
    Copy the registry values named DefaultEnvironment, DefaultUid and KernelCommandLine from one 
    Distribution's Registry Key to another Distribution's Registry Key
#>
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

Function Find-DistroRegKey{
<# .SYNOPSIS
    Return the path to the registry key for a wsl distribution
#>
    param([Parameter(Mandatory)][string]$DistroName)

    ForEach($RegKey in (Get-ChildItem -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss\")){
        $RegValues = Get-ItemProperty -Path "Registry::$($RegKey.Name)" -Name "DistributionName"
        If($RegValues.DistributionName -eq $DistroName) {
            Return $RegValues.PSPath
        }
    }
}

Function Copy-RegKeyValue{
<# .SYNOPSIS
    Copy a Property (AKA Value) from one registry key to another
#>
    param(
        [Parameter(Mandatory)][string]
        $FromKey,
        [Parameter(Mandatory)][string]
        $ToKey,
        [Parameter(Mandatory)][string]
        $ValueName
        )

        $SourceKey = Get-Item -Path $FromKey
        If($null -eq $SourceKey){
            Write-Warning "Registry Key $FromKey not found"
            Return
        }
        $ValueType = $SourceKey.GetValueKind($ValueName)
        If($null -eq $ValueType) {
            Write-Warning "Could not copy Registry Value $ValueName.`n$ValueName not found at $FromKey"
            Return
        }
        $ValueData = $SourceKey.GetValue($ValueName)

        Set-ItemProperty -Path $ToKey -Name $ValueName -Value $ValueData -Type $ValueType
}

Export-ModuleMember -Function Stop-Distro
Export-ModuleMember -Function Get-Distros
Export-ModuleMember -Function Get-DefaultDistro
Export-ModuleMember -Function Find-DistroFromLinuxFamily
Export-ModuleMember -Function Copy-DistroSettings
Export-ModuleMember -Function Find-DistroRegKey
Export-ModuleMember -Function Copy-RegKeyValue