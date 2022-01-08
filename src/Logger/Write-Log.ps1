function Write-Log
{
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, HelpMessage = 'Level of the message')]
    [ValidateSet('Verbose', 'Info', 'Warning', 'Error')]
    [string] 
    $Level,

    [Parameter(Mandatory = $true, HelpMessage = 'The message to log')]
    [string] 
    $Message
  )

  $LogToConsole = $Global:ProductivityScriptsSettings.LogToConsole
  $LogToFileDirectory = $Global:ProductivityScriptsSettings.LogToFileDirectory
  $FormattedDate = Get-Date -Format 'yyyy-MM-dd HH:mm:ss.ff'

  if ($LogToConsole)
  {
    Write-Host "[$FormattedDate] $Message" -ForegroundColor $(Get-LogColor -Level $Level)
  }

  if ($LogToFileDirectory -and (Test-Path "$LogToFileDirectory" -PathType Container))
  {
    $TodaysFileName = "$($FormattedDate.Substring(0, 10)).log"
    $TodaysFilePath = Join-Path $LogToFileDirectory $TodaysFileName
    if (!(Test-Path $TodaysFile -PathType Leaf))
    {
      New-Item $TodaysFilePath
    }
    
    Add-Content $TodaysFilePath "[$FormattedDate][$($Level.ToUpper())] $Message"
  }
}