function Write-DevonLogDebug
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
    Write-DevonLog -Level ([DevonLogLevel]::Debug) -Message $Message
  }
  
  end {}
}