function Install-SwaggerCodegen
{
  # Make sure Homebrew is installed
  Install-Homebrew

  try 
  {
    # Check if package is installed
    Write-LogInformation "Checking if swagger-codegen is installed..."
    $SwaggerCodegenVersion = Get-HomebrewVersion -Package "swagger-codegen"
    Write-LogInformation "swagger-codegen $SwaggerCodegenVersion is installed."

    try {
      # Update to latest version
      Write-LogInformation "Making sure that swagger-codegen is on latest version..."
      Invoke-HomebrewCommand -Command "upgrade" -Package "swagger-codegen"
      Write-LogInformation "swagger-codegen is on latest version."
    }
    catch {
      # Failure is not fatal, worst case swagger-codegen isn't on latest version
      Write-Warning "Making sure that swagger-codegen is on latest version failed."
    }
  }
  catch 
  {
    # Install latest version
    Write-LogWarning "swagger-codegen is not installed."
    Write-LogInformation "Installing swagger-codegen..."
    Invoke-HomebrewCommand -Command "install" -Package "swagger-codegen"
    Write-LogInformation "swagger-codegen is installed."

    # Make sure swagger-codegen is installed now
    Write-LogInformation "Checking installed swagger-codegen version..."
    $SwaggerCodegenVersion = Get-HomebrewVersion -Package "swagger-codegen"
    Write-LogInformation "swagger-codegen $SwaggerCodegenVersion is installed."
  }
}