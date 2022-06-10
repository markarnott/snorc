Function Stop-Distro{
<# .SYNOPSIS
    check to see if a distribution is running and call the wsl --terminate command if it is
#>
    param([string]$Name)

    $RunningDistros = Get-RunningDistros
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


Function Get-RunningDistros{
<# .SYNOPSIS
    Return an array of the names of wsl distributions that are running.
#>
    # Deal with wsl.exe weird UTF16 console output.
    $prev = [Console]::OutputEncoding; 
    [Console]::OutputEncoding = [System.Text.Encoding]::Unicode

    #Get a list of running WSL distros
    $WslOut = wsl.exe --list --running
    [Console]::OutputEncoding = $prev

    #Remove empty lines and the first 'banner' line
    $Running = $WslOut | Where-Object { $_ -ne "" } | Select-Object -Skip 1

    #Remove the (Default) indicator
    For($idx=0; $idx -lt $Running.Length; $idx++){
        If($Running[$idx] -match "(Default)"){
            $Running[$idx] = $Running[$idx] -replace " \(Default\)", ""
        }
    }

    Return $Running
}

Function Get-DefaultDistro{
<# .SYNOPSIS
    Return the name of the default wsl distribution
#>
    $DefaultDistroId = (Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss\").DefaultDistribution
    $DefaultDistroName = (Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss\$DefaultDistroId").DistributionName
    Return $DefaultDistroName
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
        #$DestinationKey = Get-Item -Path $ToKey
        #$DestinationKey.SetValue($ValueName, $ValueData, $ValueType)
}


Export-ModuleMember -Function Stop-Distro
Export-ModuleMember -Function Get-RunningDistros
Export-ModuleMember -Function Get-DefaultDistro
Export-ModuleMember -Function Find-DistroRegKey
Export-ModuleMember -Function Copy-RegKeyValue