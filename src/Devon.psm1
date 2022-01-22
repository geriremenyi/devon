# Initialize global variables
$Global:DevonSettings = [PSCustomObject]@{
  LoggerLevel           = [DevonLogLevel]::Trace
  LoggerDirectory       = $null
}
$Global:DevonLogStore = [System.Collections.ArrayList]::Synchronized((New-Object System.Collections.ArrayList))

# Collect and load script files 
$ScriptFiles = Get-ChildItem $PSScriptRoot -Recurse -Filter '*.ps1' -Exclude "*.Tests.ps1"
if ($ScriptFiles.Length -gt 0)
{
  $Percentage = 0
  $PercentageAddition = 100
  if (($ScriptFiles.Length - 1) -gt 0)
  {
    $PercentageAddition = $PercentageAddition / $ScriptFiles.Length - 1
  }

  # Load scripts and show progress
  foreach ($ScriptFile in $ScriptFiles)
  {
    . $ScriptFile.FullName
    Export-ModuleMember -Function $ScriptFile.BaseName -ErrorAction "Stop"
    $Percentage += $PercentageAddition
    Write-Progress -Activity "Loading productivity scripts" -PercentComplete $Percentage
  }
  Write-Progress -Activity "Loading productivity scripts" -Status "Ready" -Completed
}

# Run module initialization scripts