function Resolve-DevonTerminalCommandOutput
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
      Write-DevonLogError $Message
      return $Message
    }

    # Handle with different message resolvers
    switch -Wildcard ($Message) 
    {
      "*error*" { Write-DevonLogError $Message; break }
      "*warning*" { Write-DevonLogWarning $Message; break }
      "*succe*" { Write-DevonLogInfo $Message; break }
      default { Write-DevonLogTrace $Message }
    }

    # Return with the message
    return $Message
  }

  end {}
}