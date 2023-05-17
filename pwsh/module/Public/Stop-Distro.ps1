<# 
    .SYNOPSIS
    check to see if a distribution is running and call the wsl --terminate command if it is
#>
Function Stop-Distro{
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