function Write-LogWarning
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
    Write-Log -Level ([LogLevel]::Warning) -Message $Message
  }
  
  end {}
}