function Get-LogColor
{
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, HelpMessage = 'Level to get the color for')]
    [ValidateSet('Verbose', 'Info', 'Warning', 'Error')]
    [string] 
    $Level
  )

  $Color = switch ($Level) {
    'Verbose' { 'Cyan'; break }
    'Info' { 'White'; break }
    'Warning' { 'DarkYellow'; break }
    'Error' { 'DarkRed'; break }
    default { 'White' }
  }

  return $Color
}