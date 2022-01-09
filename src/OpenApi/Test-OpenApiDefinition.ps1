function Test-OpenApiDefinition
{
  [CmdletBinding()]
  param (
      [Parameter(Mandatory = $true, HelpMessage = "OpenAPI specification file")]
      [string]
      $SpecificationFilePath
  )

  # Make sure OpenAPI generator is installed
  Install-HomebrewPackage "openapi-generator"

  # Check file existence
  if (!(Test-Path $SpecificationFilePath -PathType "Leaf"))
  {
    $ErrorMessage = "The given specification file '$SpecificationFilePath' doesn't exist";
    Write-Error $ErrorMessage
    throw $ErrorMessage
  }

  # Run test command
  Write-LogInformation "Validating OpenAPI definition in '$SpecificationFilePath'"
  Invoke-TerminalCommand -Command "openapi-generator" -Arguments "validate -i $SpecificationFilePath" | Out-Null
  Invoke-TerminalCommand -Command "brew" -Arguments "update" | Out-Null
}