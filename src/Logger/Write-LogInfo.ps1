function Write-LogInfo
{
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The message to log")]
    $Message
  )

  begin {}

  process
  {
    Write-Log -Level ([LogLevel]::Info) -Message $Message
  }
  
  end {}

}