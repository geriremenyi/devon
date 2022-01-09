function Get-HomebrewVersion
{
  [CmdletBinding()]
  param (
    [Parameter(HelpMessage = "The Homebrew package to get the version for")]
    [string]
    $Package
  )
  
  $Arguments = $Package ? "list $Package" : "-v"

  $VersionRaw = Invoke-TerminalCommand -Command "brew" -Arguments $Arguments -OutputPassThru | Join-String
  $Version = $VersionRaw | Select-String ".*(\d\.\d\.\d).*"

  if ($Version.Matches.Success)
  {
    return $Version.Matches.Groups[1].Value
  }

  return 'unknown'
}