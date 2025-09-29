using namespace System.Collections.Generic

class CommandLibrary {
    [string]                   $Name
    [List[CompiledExpression]] $Commands
    
    CommandLibrary([string] $name) {
        $this.Name = $name
        $this.Commands = [List[CompiledExpression]]::new()
    }
    
    AddCommand([CompiledExpression] $command) {
        $this.Commands.Add($command)
    }
}

class CompiledExpression {
    [string] $Definition
	
	[string] $Label
	[bool]   $IsOptional
	[bool]   $IsChoice
	[int]    $MaxOccurences # 0 represents infinity.

    CompiledExpression([TokenizedExpression] $definition) {
		$this.Definition = $definition
		
		$tokenized = [TokenizedExpression]::new($definition)
	}
}

class TokenizedExpression {
    [string] $Definition
	
	TokenizedExpression([string] $definition) {
		$this.Definition = $definition
	}
}