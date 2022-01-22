function Write-DevonLogInfo
{
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The message to log")]
    $Message
  )

  begin {}

  process
  {
    Write-DevonLog -Level ([DevonLogLevel]::Info) -Message $Message
  }
  
  end {}

}