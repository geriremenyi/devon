function Invoke-HomebrewCommand
{
  [CmdletBinding()]
  param (
      [Parameter(HelpMessage = "The Honebrew command to execute")]
      [ValidateSet($null, "update", "list", "install", "upgrade")]
      [string]
      $Command,

      [Parameter(HelpMessage = "The Homebrew package to execute the command on")]
      [string]
      $Package,

      [Parameter(HelpMessage = "The Homebrew flag to add to the command")]
      [ValidateSet($null, "v")]
      [string]
      $Flag,

      [Parameter(HelpMessage = "Should the Homebrew messages piped through")]
      [switch]
      $PipeThrough
  )

  # Build final command
  $FinalCommand = "brew"
  if ($Command)
  {
    $FinalCommand = "$FinalCommand $Command"
  }
  if ($Package)
  {
    $FinalCommand = "$FinalCommand $Package"
  }
  if ($Flag)
  {
    $FinalCommand = "$FinalCommand -$Flag"
  }
  $FinalCommand = "$FinalCommand 2>&1"

  # Run final command with output resolution and piping if requested
  Write-LogVerbose "Running command '$FinalCommand'..."
  Invoke-Expression $FinalCommand | Resolve-HomebrewOutput -PipeThrough:$PipeThrough
  Write-LogVerbose "Running command '$FinalCommand' succeeded."
}