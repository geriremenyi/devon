function Initialize-WindowsEnvironment
{
  [CmdletBinding()]
  param (
      [Parameter(HelpMessage = "Specify the linux distribution accepted")]
      [string]
      $UnixDistribution = "Ubuntu"
  )

  # Only on Windows
  if (!$IsWindows)
  {
    Write-LogVerbose "The host OS is not Windows. Skipping setup."
  }

  # Searching for given WSL distro and installing if not there
  Write-LogInformation "Testing if WSL is enabled and properly setup with unix distribution '$UnixDistribution'..."
  $WslUnixDistributionFound = wsl -l | Where-Object { ($_ -replace "`0", "") -match  $UnixDistribution }
  if (!$WslUnixDistributionFound)
  {
    Write-LogWarning "Could not find unix distribution '$UnixDistribution'. Trying to install it..."
    wsl --install -d $UnixDistribution
  }

  # Double checking that install is complete and successful
  $WslUnixDistributionFound = wsl -l | Where-Object { ($_ -replace "`0", "") -match  $UnixDistribution }
  if (!$WslUnixDistributionFound)
  {
    Write-LogWarning "Could not find unix distribution '$UnixDistribution'. Trying to install it..."
    wsl --install -d $UnixDistribution
  }
  elseif (!($WslUnixDistributionFound -match "(Default)"))
  {
    Write-LogWarning `
      "Found unix distribution '$UnixDistribution' but it isn't the default." `
      + "Adding '-d $UnixDistribution' so commands are executed under that distribution."
  }
}