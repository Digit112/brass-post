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

# This class represents an individual token.
# The 'subexpression' TokType in particular can be made of sub-tokens including other subexpressions,
# forming a hierarchical tree.
# Other types represent individual tokens.
class TokenizedExpression {
    [string] $Definition
	
	[ExpressionTokType] $TokType
	
	# A list of options, each of which will attempt a match to the passed definition.
	# For each option, 
	[List[List[TokenizedExpression]]] $Tokens
	
	TokenizedExpression([string] $definition, [string] $tokType, [int] offset, [bool] optional) {
		$this.Definition = $definition
		$this.TokType = $tokType
		$this.Optional = $optional
		
		$this.MaxOccurences = 1
		
		if ($this.TokType == 'subexpression')
			$this.Tokens = [List[ExpressionToken]]::new()
			
			#### State ####
			
			# Read characters since the last complete token.
			[string] $buffer = ''
			
			# Index of single-quote character that began the current string.
			# -1 means we are not in a string.
			[int] string_start_i = -1
			
			# True if the previous character is an un-escaped backslash.
			[bool] escaping = false
			
			#### Iteration ####
			
			for ([int] $i = offset; $i < $definition.Length; $i++) {
				
			}
		}
		else {
			$this.Tokens = null
			$this.Label = null
		}
	}
}

enum ExpressionTokType {
	SUBEXPRESSION,
	