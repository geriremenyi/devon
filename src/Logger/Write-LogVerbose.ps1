function Write-LogVerbose
{
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = 'The message to log')]
    [string] 
    $Message
  )

  begin {}

  process
  {
    Write-Log -Level "Verbose" -Message $Message
  }
  
  end {}
  
}