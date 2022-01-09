function Install-HomebrewPackage
{
  [CmdletBinding()]
  param (
      [Parameter(HelpMessage = "The Honebrew package to install")]
      [string]
      $Package
  )
      
  # Make sure Homebrew is installed
  Install-Homebrew

  try
  {
    # Check if package is installed
    Write-LogInformation "Checking if $Package is installed..."
    $PackageVersion = Get-HomebrewVersion -Package $Package
    Write-LogInformation "$Package $PackageVersion is installed."

    try {
      # Update to latest version
      Write-LogInformation "Making sure that $Package is on latest version..."
      Invoke-TerminalCommand -Command "brew" -Arguments "upgrade $Package"
      Write-LogInformation "$Package is on latest version."
    }
    catch {
      # Failure is not fatal, worst case package isn't on latest version
      Write-LogWarning "Making sure that $Package is on latest version failed. Error: $_"
    }
  }
  catch 
  {
    # Install latest version
    Write-LogWarning "$Package is not installed."
    Write-LogInformation "Installing $Package..."
    Invoke-TerminalCommand -Command "brew" -Arguments "install $Package"
    Write-LogInformation "$Package is installed."

    # Make sure package is installed now
    Write-LogInformation "Checking installed $Package version..."
    $PackageVersion = Get-HomebrewVersion -Package $Package
    Write-LogInformation "$Package $PackageVersion is installed."
  }
}