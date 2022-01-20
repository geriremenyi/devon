function Resolve-TerminalCommandOutput
{
  param (
      [Parameter(ValueFromPipeline = $true, HelpMessage = "Output message to resolve")]
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
      Write-LogError $Message
      return $Message
    }

    # Handle with different message resolvers
    switch -Wildcard ($Message) 
    {
      "*error*" { Write-LogError $Message; break }
      "*warning*" { Write-LogWarning $Message; break }
      "*succe*" { Write-LogInfo $Message; break }
      default { Write-LogTrace $Message }
    }

    # Return with the message
    return $Message
  }

  end {}
}