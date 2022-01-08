function Write-LogInformation
{
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The message to log")]
    $Message
  )

  begin {}

  process
  {
    Write-Log -Level "Info" -Message $Message
  }
  
  end {}

}