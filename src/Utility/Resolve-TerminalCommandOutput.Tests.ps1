BeforeAll {
  # Dependendencies
  . $PSScriptRoot/../Logger/Write-LogTrace.ps1
  . $PSScriptRoot/../Logger/Write-LogInfo.ps1
  . $PSScriptRoot/../Logger/Write-LogWarning.ps1
  . $PSScriptRoot/../Logger/Write-LogError.ps1

  # Mock dependencies
  Mock Write-LogTrace -Verifiable
  Mock Write-LogInfo -Verifiable
  Mock Write-LogWarning -Verifiable
  Mock Write-LogError -Verifiable

  # Script under test
  . $PSScriptRoot/Resolve-TerminalCommandOutput.ps1
}

Describe "Resolve-TerminalCommandOutput" {
  Context "doesn't write to logs" {
    It "when message is not passed" {
      # Arrange
  
      # Act
      $ResolvedMessage = Resolve-TerminalCommandOutput
  
      # Assert
      $ResolvedMessage | Should -BeNullOrEmpty
      Should -Invoke -CommandName Write-LogTrace -Times 0
      Should -Invoke -CommandName Write-LogInfo -Times 0
      Should -Invoke -CommandName Write-LogWarning -Times 0
      Should -Invoke -CommandName Write-LogError -Times 0
    }
  
    It "when message is empty string" {
      # Arrange
      $Message = ""

      # Act
      $ResolvedMessage = Resolve-TerminalCommandOutput $Message
  
      # Assert
      $ResolvedMessage | Should -BeNullOrEmpty
      Should -Invoke -CommandName Write-LogTrace -Times 0
      Should -Invoke -CommandName Write-LogInfo -Times 0
      Should -Invoke -CommandName Write-LogWarning -Times 0
      Should -Invoke -CommandName Write-LogError -Times 0
    }
  
    It "when message is only null chars string" {
      # Arrange
      $Message = "`0`0`0"

      # Act
      $ResolvedMessage = Resolve-TerminalCommandOutput $Message
      
      # Assert
      $ResolvedMessage | Should -BeNullOrEmpty
      Should -Invoke -CommandName Write-LogTrace -Times 0
      Should -Invoke -CommandName Write-LogInfo -Times 0
      Should -Invoke -CommandName Write-LogWarning -Times 0
      Should -Invoke -CommandName Write-LogError -Times 0
    }
  }

  Context "when coming from error output" {
    It "writes to error log if text doesn't contain 'warning'" {
      # Arrange
      $Message = "This is a message coming from the error output"
 
      # Act
      $ResolvedMessage = Resolve-TerminalCommandOutput $Message -IsErrorOutput
  
      # Assert
      $ResolvedMessage | Should -Be $Message
      Should -Invoke -CommandName Write-LogTrace -Times 0
      Should -Invoke -CommandName Write-LogInfo -Times 0
      Should -Invoke -CommandName Write-LogWarning -Times 0
      Should -Invoke -CommandName Write-LogError -Times 1
    }
  
    It "writes to warning log if text contains 'warning'" {
      # Arrange
      $Message = "[Warning]: This is a message coming from the problematic output (can't write err.. because that triggers a differnt branch)"
 
      # Act
      $ResolvedMessage = Resolve-TerminalCommandOutput $Message -IsErrorOutput
  
      # Assert
      $ResolvedMessage | Should -Be $Message
      Should -Invoke -CommandName Write-LogTrace -Times 0
      Should -Invoke -CommandName Write-LogInfo -Times 0
      Should -Invoke -CommandName Write-LogWarning -Times 1
      Should -Invoke -CommandName Write-LogError -Times 0
    }
  }

  Context "writes to error log" {
    It "when message contains 'error'" {
      # Arrange
      $Message = "This is a message which contains an error in the text"
 
      # Act
      $ResolvedMessage = Resolve-TerminalCommandOutput $Message
  
      # Assert
      $ResolvedMessage | Should -Be $Message
      Should -Invoke -CommandName Write-LogTrace -Times 0
      Should -Invoke -CommandName Write-LogInfo -Times 0
      Should -Invoke -CommandName Write-LogWarning -Times 0
      Should -Invoke -CommandName Write-LogError -Times 1
    }
  }

  Context "writes to warning log" {
    It "when message contains 'warning'" {
      # Arrange
      $Message = "This is a message which contains an warning in the text"
 
      # Act
      $ResolvedMessage = Resolve-TerminalCommandOutput $Message
  
      # Assert
      $ResolvedMessage | Should -Be $Message
      Should -Invoke -CommandName Write-LogTrace -Times 0
      Should -Invoke -CommandName Write-LogInfo -Times 0
      Should -Invoke -CommandName Write-LogWarning -Times 1
      Should -Invoke -CommandName Write-LogError -Times 0
    }
  }

  Context "writes to information log" {
    It "when message contains 'success'" {
      # Arrange
      $Message = "This is a message which contains an success in the text"
 
      # Act
      $ResolvedMessage = Resolve-TerminalCommandOutput $Message
  
      # Assert
      $ResolvedMessage | Should -Be $Message
      Should -Invoke -CommandName Write-LogTrace -Times 0
      Should -Invoke -CommandName Write-LogInfo -Times 1
      Should -Invoke -CommandName Write-LogWarning -Times 0
      Should -Invoke -CommandName Write-LogError -Times 0
    }

    It "when message contains 'succeeded'" {
      # Arrange
      $Message = "This is a message which contains an succeeded in the text"
 
      # Act
      $ResolvedMessage = Resolve-TerminalCommandOutput $Message
  
      # Assert
      $ResolvedMessage | Should -Be $Message
      Should -Invoke -CommandName Write-LogTrace -Times 0
      Should -Invoke -CommandName Write-LogInfo -Times 1
      Should -Invoke -CommandName Write-LogWarning -Times 0
      Should -Invoke -CommandName Write-LogError -Times 0
    }
  }

  Context "writes to verbose log" {
    It "when text doesn't contain special token" {
      # Arrange
      $Message = "This is a message which contains actually nothing interesting"
 
      # Act
      $ResolvedMessage = Resolve-TerminalCommandOutput $Message
  
      # Assert
      $ResolvedMessage | Should -Be $Message
      Should -Invoke -CommandName Write-LogTrace -Times 1
      Should -Invoke -CommandName Write-LogInfo -Times 0
      Should -Invoke -CommandName Write-LogWarning -Times 0
      Should -Invoke -CommandName Write-LogError -Times 0
    }
  }
}