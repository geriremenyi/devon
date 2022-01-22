function Get-DevonLogColor
{
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, HelpMessage = 'Level to get the color for')]
    [DevonLogLevel]
    $Level
  )

  $Color = switch ($Level) {
    ([DevonLogLevel]::Trace)   { 'Cyan'; break }
    ([DevonLogLevel]::Debug)   { 'Yellow'; break }
    ([DevonLogLevel]::Info)    { 'White'; break }
    ([DevonLogLevel]::Warning) { 'DarkYellow'; break }
    ([DevonLogLevel]::Error)   { 'Red'; break }
    ([DevonLogLevel]::Fatal)   { 'DarkRed'; break }
    default { 'White' }
  }

  return $Color
}