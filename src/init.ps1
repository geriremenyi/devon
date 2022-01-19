[CmdletBinding()]
param (
    [Parameter(HelpMessage = "Specify the linux subsystem to work on if host OS is Windows")]
    [string]
    $UnixDistributionIfWindows = "Ubuntu"
)

# Initialize global variables
$Global:ProductivityScriptsSettings = [PSCustomObject]@{
  LogLevel = 'Verbose'
  LogToConsole = $true
  LogToFileDirectory = $null
}
$ErrorActionPreference = 'Stop'

# Collect script files 
$ScriptFiles = Get-ChildItem $PSScriptRoot -Recurse -Filter '*.ps1'
if ($ScriptFiles.Length -eq 0)
{
  return
}

# Calculate progress indicator steps
$Percentage = 0
$PercentageAddition = 100
if (($ScriptFiles.Length - 1) -ne 0)
{
  $PercentageAddition = $PercentageAddition / $ScriptFiles.Length - 1
}

# Load scripts and show progress
foreach ($File in $ScriptFiles)
{
  . $File.FullName
  Export-ModuleMember -Function $File.BaseName -ErrorAction 'Stop'
  $Percentage += $PercentageAddition
  Write-Progress -Activity "Loading productivity scripts" -PercentComplete $Percentage
}
Write-Progress -Activity "Loading productivity scripts" -Status 'Ready' -Completed

# Initialize environment
Initialize-WindowsEnvironment -UnixDistributionIfWindows $UnixDistributionIfWindows