$ModuleName = "Pester"
if (!(Get-Module | Where-Object {$_.Name -eq $ModuleName})) 
{
  if (Get-Module -ListAvailable | Where-Object {$_.Name -eq $m})
  {
    Import-Module Pester -PassThru
  }
  else 
  {
    Install-Module Pester -Force -ErrorAction "Stop"
    Import-Module Pester -PassThru
  }
}