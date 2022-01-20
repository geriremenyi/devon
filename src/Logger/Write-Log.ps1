function Write-Log
{
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, HelpMessage = 'Level of the message')]
    [LogLevel]
    $Level,

    [Parameter(Mandatory = $true, HelpMessage = 'The message to log')]
    [string] 
    $Message
  )

  # Log level is lower severity than the message level coming in
  # Just drop the message and return
  if ($Global:ProductivityScriptsSettings.LoggerLevel.value__ -lt $Level.value__)
  {
    return
  }

  # Write the message to the host
  $FormattedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss.ff"
  Write-Host "[$FormattedDate] $Message" -ForegroundColor (Get-LogColor -Level $Level)

  # Write the message to file if log to file is set and directory is valid
  if ($Global:ProductivityScriptsSettings.LoggerDirectory -and (Test-Path "$($Global:ProductivityScriptsSettings.LoggerDirectory)" -PathType "Container"))
  {
    $TodaysFileName = "$($FormattedDate.Substring(0, 10)).log"
    $TodaysFilePath = Join-Path $Global:ProductivityScriptsSettings.LoggerDirectory $TodaysFileName
    if (!(Test-Path $TodaysFilePath -PathType "Leaf"))
    {
      New-Item $TodaysFilePath
    }
      
    Add-Content $TodaysFilePath "[$FormattedDate][$($Level.ToString().ToUpper())] $Message"
  }
}