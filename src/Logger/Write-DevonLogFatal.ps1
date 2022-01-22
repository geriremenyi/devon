function Write-DevonLogFatal
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
    Write-DevonLog -Level ([DevonLogLevel]::Fatal) -Message $Message
  }
  
  end {}
}