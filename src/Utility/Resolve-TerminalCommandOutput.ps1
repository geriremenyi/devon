function Resolve-TerminalCommandOutput
{
  param (
      [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Output message to resolve")]
      $Message,

      [Parameter(HelpMessage = "Is the source error output")]
      [switch]
      $IsErrorOutput
  )

  begin {}

  process 
  {
    # If empty just return
    if (!($Message -replace "`0", ""))
    {
      return
    }

    # If coming from error output
    if ($IsErrorOutput.IsPresent -and !($Message -match "warning"))
    {
      return Write-LogError $Message
      return $Message
    }

    # Handle with different message resolvers
    switch -Wildcard ($Message) 
    {
      "*error." { Write-LogError $Message; break }
      "*warning*" { Write-LogWarning $Message; break }
      "*succe*" { Write-LogInformation $Message; break }
      default { Write-LogVerbose $Message }
    }

    # Return with the message
    return $Message
  }

  end {}
}