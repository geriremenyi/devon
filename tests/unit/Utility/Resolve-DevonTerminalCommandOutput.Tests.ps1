BeforeAll {
  # Dependendencies
  . $PSScriptRoot/../../../src/Logger/Write-DevonLogTrace.ps1
  . $PSScriptRoot/../../../src/Logger/Write-DevonLogInfo.ps1
  . $PSScriptRoot/../../../src/Logger/Write-DevonLogWarning.ps1
  . $PSScriptRoot/../../../src/Logger/Write-DevonLogError.ps1

  # Mock dependencies
  Mock Write-DevonLogTrace -Verifiable
  Mock Write-DevonLogInfo -Verifiable
  Mock Write-DevonLogWarning -Verifiable
  Mock Write-DevonLogError -Verifiable

  # Script under test
  . $PSScriptRoot/../../../src/Utility/Resolve-DevonTerminalCommandOutput.ps1
}

Describe "Resolve-DevonTerminalCommandOutput" -Tag "Unit" {
  Context "doesn't write to logs" {
    It "when message is not passed" {
      # Arrange
  
      # Act
      $ResolvedMessage = Resolve-DevonTerminalCommandOutput
  
      # Assert
      $ResolvedMessage | Should -BeNullOrEmpty
      Should -Invoke -CommandName Write-DevonLogTrace -Times 0
      Should -Invoke -CommandName Write-DevonLogInfo -Times 0
      Should -Invoke -CommandName Write-DevonLogWarning -Times 0
      Should -Invoke -CommandName Write-DevonLogError -Times 0
    }
  
    It "when message is empty string" {
      # Arrange
      $Message = ""

      # Act
      $ResolvedMessage = Resolve-DevonTerminalCommandOutput $Message
  
      # Assert
      $ResolvedMessage | Should -BeNullOrEmpty
      Should -Invoke -CommandName Write-DevonLogTrace -Times 0
      Should -Invoke -CommandName Write-DevonLogInfo -Times 0
      Should -Invoke -CommandName Write-DevonLogWarning -Times 0
      Should -Invoke -CommandName Write-DevonLogError -Times 0
    }
  
    It "when message is only null chars string" {
      # Arrange
      $Message = "`0`0`0"

      # Act
      $ResolvedMessage = Resolve-DevonTerminalCommandOutput $Message
      
      # Assert
      $ResolvedMessage | Should -BeNullOrEmpty
      Should -Invoke -CommandName Write-DevonLogTrace -Times 0
      Should -Invoke -CommandName Write-DevonLogInfo -Times 0
      Should -Invoke -CommandName Write-DevonLogWarning -Times 0
      Should -Invoke -CommandName Write-DevonLogError -Times 0
    }
  }

  Context "when coming from error output" {
    It "writes to error log if text doesn't contain 'warning'" {
      # Arrange
      $Message = "This is a message coming from the error output"
 
      # Act
      $ResolvedMessage = Resolve-DevonTerminalCommandOutput $Message -IsErrorOutput
  
      # Assert
      $ResolvedMessage | Should -Be $Message
      Should -Invoke -CommandName Write-DevonLogTrace -Times 0
      Should -Invoke -CommandName Write-DevonLogInfo -Times 0
      Should -Invoke -CommandName Write-DevonLogWarning -Times 0
      Should -Invoke -CommandName Write-DevonLogError -Times 1
    }
  
    It "writes to warning log if text contains 'warning'" {
      # Arrange
      $Message = "[Warning]: This is a message coming from the problematic output (can't write err.. because that triggers a differnt branch)"
 
      # Act
      $ResolvedMessage = Resolve-DevonTerminalCommandOutput $Message -IsErrorOutput
  
      # Assert
      $ResolvedMessage | Should -Be $Message
      Should -Invoke -CommandName Write-DevonLogTrace -Times 0
      Should -Invoke -CommandName Write-DevonLogInfo -Times 0
      Should -Invoke -CommandName Write-DevonLogWarning -Times 1
      Should -Invoke -CommandName Write-DevonLogError -Times 0
    }
  }

  Context "writes to error log" {
    It "when message contains 'error'" {
      # Arrange
      $Message = "This is a message which contains an error in the text"
 
      # Act
      $ResolvedMessage = Resolve-DevonTerminalCommandOutput $Message
  
      # Assert
      $ResolvedMessage | Should -Be $Message
      Should -Invoke -CommandName Write-DevonLogTrace -Times 0
      Should -Invoke -CommandName Write-DevonLogInfo -Times 0
      Should -Invoke -CommandName Write-DevonLogWarning -Times 0
      Should -Invoke -CommandName Write-DevonLogError -Times 1
    }
  }

  Context "writes to warning log" {
    It "when message contains 'warning'" {
      # Arrange
      $Message = "This is a message which contains an warning in the text"
 
      # Act
      $ResolvedMessage = Resolve-DevonTerminalCommandOutput $Message
  
      # Assert
      $ResolvedMessage | Should -Be $Message
      Should -Invoke -CommandName Write-DevonLogTrace -Times 0
      Should -Invoke -CommandName Write-DevonLogInfo -Times 0
      Should -Invoke -CommandName Write-DevonLogWarning -Times 1
      Should -Invoke -CommandName Write-DevonLogError -Times 0
    }
  }

  Context "writes to information log" {
    It "when message contains 'success'" {
      # Arrange
      $Message = "This is a message which contains an success in the text"
 
      # Act
      $ResolvedMessage = Resolve-DevonTerminalCommandOutput $Message
  
      # Assert
      $ResolvedMessage | Should -Be $Message
      Should -Invoke -CommandName Write-DevonLogTrace -Times 0
      Should -Invoke -CommandName Write-DevonLogInfo -Times 1
      Should -Invoke -CommandName Write-DevonLogWarning -Times 0
      Should -Invoke -CommandName Write-DevonLogError -Times 0
    }

    It "when message contains 'succeeded'" {
      # Arrange
      $Message = "This is a message which contains an succeeded in the text"
 
      # Act
      $ResolvedMessage = Resolve-DevonTerminalCommandOutput $Message
  
      # Assert
      $ResolvedMessage | Should -Be $Message
      Should -Invoke -CommandName Write-DevonLogTrace -Times 0
      Should -Invoke -CommandName Write-DevonLogInfo -Times 1
      Should -Invoke -CommandName Write-DevonLogWarning -Times 0
      Should -Invoke -CommandName Write-DevonLogError -Times 0
    }
  }

  Context "writes to verbose log" {
    It "when text doesn't contain special token" {
      # Arrange
      $Message = "This is a message which contains actually nothing interesting"
 
      # Act
      $ResolvedMessage = Resolve-DevonTerminalCommandOutput $Message
  
      # Assert
      $ResolvedMessage | Should -Be $Message
      Should -Invoke -CommandName Write-DevonLogTrace -Times 1
      Should -Invoke -CommandName Write-DevonLogInfo -Times 0
      Should -Invoke -CommandName Write-DevonLogWarning -Times 0
      Should -Invoke -CommandName Write-DevonLogError -Times 0
    }
  }
}