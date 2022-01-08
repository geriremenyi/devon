function Resolve-HomebrewOutput
{
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The output message")]
    $Message,

    [Parameter(HelpMessage = "Should the message piped through")]
    [switch]
    $PipeThrough
  )

  begin {}

  process
  {
    # Empty
    if (!$Message)
    {
      return
    }

    # Error
    if (($Message | Select-String "Error:.*").Matches.Success)
    {
      Write-LogError $Message
      throw $Message
    }

    # Warning
    if (($Message | Select-String "Warning:.*").Matches.Success)
    {
      Write-LogWarning $Message
      return
    }
  
    # Information
    if (($Message | Select-String "Info.*").Matches.Success)
    {
      Write-LogInformation $Message
      return
    }

    # Verbose
    Write-LogVerbose $Message

    # If pipe through is requested
    if ($PipeThrough.IsPresent)
    {
      return $Message
    }
  }

  end {}
}