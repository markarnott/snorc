<# 
    .SYNOPSIS
    Return an array of the names of the installed wsl distributions.
#>
Function Get-Distros{
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