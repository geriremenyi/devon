function Get-HomebrewVersion
{
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage = "The Homebrew package to get the version for")]
    [string]
    $Package
  )
  
  $Command = $null
  $Flag = 'v'
  if ($Package)
  {
    $Command = "list"
    $Flag = $null
  }

  $VersionRaw = Invoke-HomebrewCommand -Command $Command -Package $Package -Flag $Flag -PipeThrough | Join-String
  $Version = $VersionRaw | Select-String ".*(\d\.\d\.\d).*"

  if ($Version.Matches.Success)
  {
    return $Version.Matches.Groups[1].Value
  }

  return 'unknown'
}