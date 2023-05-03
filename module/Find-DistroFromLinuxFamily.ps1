<# 
    .SYNOPSIS
    Probe the WSL instances to find a type of linux

    .NOTES 
    We use the /etc/os-release data from a WSL instance to figure out what kind of linux it is.  
    We need an ubuntu instance for the get-podman.sh installer
#>
Function Find-DistroFromLinuxFamily{
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