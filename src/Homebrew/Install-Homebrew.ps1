function Install-Homebrew
{
  [CmdletBinding()]
  param (
      [Parameter(HelpMessage = "Should the interactive mode disabled")]
      [switch]
      $InteractiveModeDisabled
  )
  try 
  {
    # Check installed
    Write-LogInformation "Checking if Homebrew is installed..."
    $HomebrewVersion = Get-HomebrewVersion
    Write-LogInformation "Homebrew $HomebrewVersion is installed."

    try {
      # Update Homebrew to latest version
      Write-LogInformation "Making sure that Homebrew is on latest version..."
      Invoke-TerminalCommand -Command "brew" -Arguments "update"
      Write-LogInformation "Homebrew is on latest version."
    }
    catch {
      # Failure is not fatal, worst case Homebrew isn't on latest version
      Write-LogWarning "Making sure Homebrew is on latest version failed. Error: $_"
    }
  }
  catch
  {
    # Not installed
    # Download installer
    Write-LogWarning "Homebrew is not istalled."
    Write-LogInformation "Installing Homebrew..."
    $TempFilePath = Join-Path -Path $([System.IO.Path]::GetTempPath()) -ChildPath 'brew_install.sh'
    $BrewInstaller = "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
    $CurrentProgressPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $BrewInstaller -OutFile $TempFilePath
    $ProgressPreference = $CurrentProgressPreference

    # On Windows WSL 2 has to be enabled
    if ($IsWindows)
    {
      try 
      {
        $WslVersion = Invoke-Command "wsl -l -v" # TODO test this on Windows and check for v2
        if (!$WslVersion)
        {
          $ErrorMessage = 
            "WSL is not enabled. Homebrew installation cannot proceed."
            "Please check the documentation to enable WSL: https://docs.microsoft.com/en-us/windows/wsl/install"
          Write-Error $ErrorMessage
          throw $ErrorMessage
        }
      }
      catch 
      {
        Write-LogError
          "The command 'wsl -l -v' failed."
          "Please check that you are on at least the Windows version which supports this command: https://docs.microsoft.com/en-us/windows/wsl/install#prerequisites"
        throw $_
      }
    }

    # Run installation
    Invoke-TerminalCommand -Command "chmod" -Arguments "+x $TempFilePath"
    if ($InteractiveModeDisabled.IsPresent)
    {
      $TempFilePath = "$TempFilePath >/dev/null"
    }
    Invoke-TerminalCommand -Command "bash" -Arguments "-c $TempFilePath";

    # Make sure Homebrew is installed now
    # If this one throws that will bubble up 
    # This is a non recoverable exception
    Write-LogInformation "Checking installed Homebrew version"
    $HomebrewVersion = Get-HomebrewVersion
    Write-LogInformation "Homebrew $HomebrewVersion is installed."
  }
}