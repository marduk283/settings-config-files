# Variables
# $pclouddir = "N:"

<#
.SYNOPSIS
Simplifies setting environment variables
Alias: sev

.PARAMETER Name
Variable name
Alias: n

.PARAMETER Value
Variable value
Alias: v

.EXAMPLE
Set-EnvVar -Name "STARSHIP_CONFIG" -Value "N:\git-repos\settings-config-files\starship\starship.toml"
#>

<#
function Set-EnvVar {
    param(
        [Parameter(Mandatory)]
        [Alias("n")]
        [string[]]
        $Name,

        [Parameter(Mandatory)]
        [Alias("d")]
        [string[]]
        $Value
    )

    [System.Environment]::SetEnvironmentVariable($Name,$Value,[System.EnvironmentVariableTarget]::Machine)

    Write-Output "Environment variable $Name set to $Value"
}
#>

<#
.SYNOPSIS
Simplifies changing registry settings
Alias: sr

.PARAMETER Path
Registry key
Alias: p

.PARAMETER Name
Name
Alias: n

.PARAMETER Type
Data type
Alias: t

.PARAMETER Value
Data value
Alias: d

.EXAMPLE
sr -p HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName -n ComputerName -t string -v JK-DESKTOP
#>
#New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes" -Force | New-ItemProperty -Name "Segoe UI" -PropertyType "String" -Value "$args" -Force | Out-Null

<#
.SYNOPSIS
Cleans the system by removing temporary files, optimizing disks, and scanning for corrupted files
Alias: cs
#>

function Clean-System {
    # Remove files from temp folders
    Remove-Item -Path "$env:LOCALAPPDATA\Temp" -Recurse -Force
    Remove-Item -Path "C:\Temp" -Recurse -Force
    Remove-Item -Path "$env:SystemRoot\Prefetch" -Recurse -Force

    # Run disk cleanup
    cleanmgr /sagerun:1

    # Open Bleachbit
    Start-Process "${env:ProgramFiles(x86)}\BleachBit\bleachbit.exe"

    # Optimize/defrag drives
    $drives = Get-PSDrive | Where-Object Provider -match "FileSystem" | Where-Object Name -notmatch "Temp" | Select-Object Name | Out-String -Stream
    $drives.foreach{
        Optimize-Volume -DriveLetter $_ -Verbose
    }

    # Repair system files
    sfc /scannow
    Dism /Online /Cleanup-Image -RestoreHealth

    Write-Output "System cleaned."
}

<#
.SYNOPSIS
Simplifies youtube-dl for downloading mp3's and mp4's

.PARAMETER output
Output directory
Alias: o

.PARAMETER url
URL
Alias: u

.PARAMETER format
File format (either mp3 or mp4)
Alias: f

.PARAMETER openfolder
Opens the folder after downloading
Alias: of

.EXAMPLE
ytdl -u https://www.youtube.com/watch?v=dQw4w9WgXcQ -f mp4 -o C:\Users\dave\Music
#>

function ytdl {
    param(
        [Alias("o")]
        [string[]]
        $output = $pwd,

        [Parameter(Mandatory)]
        [Alias("u")]
        [string[]]
        $url,

        [Parameter(Mandatory)]
        [Alias("f")]
        [string[]]
        $format,

        [Alias("of")]
        [switch]
        $openfolder = $false
    )

    $dir = $pwd
    Set-Location $output

    if ($format -eq "mp3") {
        youtube-dl -x --audio-format mp3 --audio-quality 0 $url
    }
    
    if ($format -eq "mp4") {
        youtube-dl -f mp4 $url
    }

    Set-Location $dir
    Write-Output "Video downloaded to $output"

    if ($openfolder) {
        explorer $output
    }
}

<#
.SYNOPSIS
Enables the lock screen
Alias: els
#>

function Enable-LockScreen {
    New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Force | New-ItemProperty -Name "NoLockScreen" -PropertyType "DWord" -Value "0" -Force

    Write-Output "Lock screen enabled."
}

<#
.SYNOPSIS
Disables the lock screen
Alias: dls
#>

function Disable-LockScreen {
    New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Force | New-ItemProperty -Name "NoLockScreen" -PropertyType "DWord" -Value "1" -Force

    Write-Output "Lock screen disabled."
}

<#
# Change system font
function Set-SystemFont {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Force | New-ItemProperty -Name "Segoe UI (TrueType)" -PropertyType "String" -Value "" -Force | Out-Null
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Force | New-ItemProperty -Name "Segoe UI Black (TrueType)" -PropertyType "String" -Value "" -Force | Out-Null
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Force | New-ItemProperty -Name "Segoe UI Bold (TrueType)" -PropertyType "String" -Value "" -Force | Out-Null
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Force | New-ItemProperty -Name "Segoe UI Historic (TrueType)" -PropertyType "String" -Value "" -Force | Out-Null
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Force | New-ItemProperty -Name "Segoe UI Italic (TrueType)" -PropertyType "String" -Value "" -Force | Out-Null
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Force | New-ItemProperty -Name "Segoe UI Light (TrueType)" -PropertyType "String" -Value "" -Force | Out-Null
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Force | New-ItemProperty -Name "Segoe UI Light Italic (TrueType)" -PropertyType "String" -Value "" -Force | Out-Null
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Force | New-ItemProperty -Name "Segoe UI Semibold (TrueType)" -PropertyType "String" -Value "" -Force | Out-Null
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Force | New-ItemProperty -Name "Segoe UI Semibold Italic (TrueType)" -PropertyType "String" -Value "" -Force | Out-Null
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Force | New-ItemProperty -Name "Segoe UI Semilight (TrueType)" -PropertyType "String" -Value "" -Force | Out-Null
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Force | New-ItemProperty -Name "Segoe UI Semilight Italic (TrueType)" -PropertyType "String" -Value "" -Force | Out-Null
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes" -Force | New-ItemProperty -Name "Segoe UI" -PropertyType "String" -Value "$args" -Force | Out-Null
}
#>

<#
.SYNOPSIS
Gets a list of my custom functions
Alias: gf
#>

function Get-Functions {
    Write-Output "Get-Functions (gf)"
    Write-Output "Clean-System (cs)"
    Write-Output "ytdl"
    Write-Output "Enable-LockScreen (els)"
    Write-Output "Disable-LockScreen (dls)"
    Write-Output "Set-EnvVar (sev)"
}

# Set aliases
Set-Alias -Name "cs" -Value "Clean-System" -Option AllScope -Force
Set-Alias -Name "els" -Value "Enable-LockScreen" -Option AllScope -Force
Set-Alias -Name "dls" -Value "Disable-LockScreen" -Option AllScope -Force
Set-Alias -Name "gf" -Value "Get-Functions" -Option AllScope -Force
Set-Alias -Name "sev" -Value "Set-EnvVar" -Option AllScope -Force
#Set-Alias -Name "ssf" -Value "Set-SystemFont" -Option AllScope -Force

# Copy settings and config files
Copy-Item "N:\git-repos\settings-config-files\powershell\user_profile.ps1" "$env:CMDER_ROOT\config\user_profile.ps1" -Force

<#
Copy-Item "$env:CMDER_ROOT\config\user-ConEmu.xml" "$sync\Settings & Config Files\Cmder" -Force
Copy-Item "$env:CMDER_ROOT\bin\jacksonPoshTheme.json" "$sync\Settings & Config Files\Cmder" -Force
#>

# Set environment variables
$env:STARSHIP_CONFIG = "N:\git-repos\settings-config-files\starship\starship.toml"

# Initialize starship prompt
Invoke-Expression (&starship init powershell)