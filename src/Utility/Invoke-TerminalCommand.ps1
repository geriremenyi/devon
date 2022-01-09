function Invoke-TerminalCommand
{
  [CmdletBinding()]
  param (
      [Parameter(Mandatory = $true, HelpMessage = "The command to invoke")]
      [string]
      $Command,

      [Parameter(HelpMessage = "The arguments of the command to invoke")]
      [string]
      $Arguments,

      [Parameter(HelpMessage = "Verb to pass to the process start")]
      [string]
      $Verb,

      [Parameter(HelpMessage = "Should the invoked command's output passed back to caller in an array")]
      [switch]
      $OutputPassThru
  )
  
  # Log the invoked command
  $FullCommand = "$Command$($Arguments ? (" $Arguments") : '')"
  Write-LogVerbose "Running command '$FullCommand'..."

  # Create separate process
  $ProcessStartInfo = New-Object System.Diagnostics.ProcessStartInfo -Property @{
    FileName = $Command
    Arguments = $Arguments
    Verb = $Verb
    UseShellExecute = $false
    CreateNoWindow = $false
    RedirectStandardOutput = $true
    RedirectStandardError = $true
    RedirectStandardInput = $true
  }
  $Process = New-Object System.Diagnostics.Process
  $Process.StartInfo = $ProcessStartInfo

  # Register event subscribes for output/error events
  $OutputCapture = @{
    ShouldCapture = $OutputPassThru.IsPresent
    LogStore = [System.Collections.ArrayList]::Synchronized((New-Object System.Collections.ArrayList))
  }
  $OutEvent = Register-ObjectEvent `
                -Action {
                  $Message = $Event.SourceEventArgs.Data | Resolve-TerminalCommandOutput
                  $Message -and $event.MessageData.ShouldCapture ? $event.MessageData.LogStore.Add($Event.SourceEventArgs.Data) : [void]'noop'
                }`
                -InputObject $Process `
                -EventName OutputDataReceived `
                -MessageData $OutputCapture
  $ErrEvent = Register-ObjectEvent `
                -Action {
                  $Message = $Event.SourceEventArgs.Data | Resolve-TerminalCommandOutput -IsErrorOutput
                  $Message -and $event.MessageData.ShouldCapture ? $event.MessageData.LogStore.Add($Event.SourceEventArgs.Data) : [void]'noop'
                } `
                -InputObject $Process `
                -EventName ErrorDataReceived `
                -MessageData $OutputCapture

  # Start the process and wait for it's execution
  [void]$Process.Start()
  $Process.BeginOutputReadLine()
  $Process.BeginErrorReadLine()
  $Process.WaitForExit(-1) | Out-Null
  $Process.WaitForExit() | Out-Null

  # Unregister event subscribers
  $OutEvent.Name, $ErrEvent.Name | ForEach-Object {Unregister-Event -SourceIdentifier $_}

  # If separate process failed throw otherwise just log success
  if ($Process.ExitCode -ne 0)
  {
    $ErrorMessage = "Running the command '$FullCommand' failed. Process exited with $($Process.ExitCode)."
    Write-LogError $ErrorMessage
    throw $ErrorMessage
  }
  Write-LogVerbose "Running command '$FullCommand' succeeded."

  # Return the command output for further processing if requested
  # The return type is a pipeable synchronized list
  if ($OutputPassThru.IsPresent)
  {
    return $OutputCapture.LogStore
  }
}