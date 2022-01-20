function Get-LogColor
{
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, HelpMessage = 'Level to get the color for')]
    [LogLevel]
    $Level
  )

  $Color = switch ($Level) {
    ([LogLevel]::Trace)   { 'Cyan'; break }
    ([LogLevel]::Debug)   { 'Yellow'; break }
    ([LogLevel]::Info)    { 'White'; break }
    ([LogLevel]::Warning) { 'DarkYellow'; break }
    ([LogLevel]::Error)   { 'Red'; break }
    ([LogLevel]::Fatal)   { 'DarkRed'; break }
    default { 'White' }
  }

  return $Color
}