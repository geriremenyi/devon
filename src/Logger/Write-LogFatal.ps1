function Write-LogFatal
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
    Write-Log -Level ([LogLevel]::Fatal) -Message $Message
  }
  
  end {}
}