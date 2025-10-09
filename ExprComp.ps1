using namespace System.Collections.Generic

#### ExprComp - Expression Compilation ####
# The Expression Compilation Module compiles expressions as per the command definition syntax specified in 'docs\Command Definition Syntax.md'
# The module implements an extremely flexible metalanguage very reminiscent of ABNF.

class ExprCompCompiledExpression {
    [string] $Definition
	
	[string] $Label
	[bool]   $IsOptional
	[bool]   $IsChoice
	[int]    $MaxOccurences # 0 represents infinity.

    ExprCompCompiledExpression([ExprCompTokenizedExpression] $definition) {
		$this.Definition = $definition
		
		$tokenized = [ExprCompTokenizedExpression]::new($definition)
	}
}

# Represents a single token which will be of type subexpression, string, or type.
class ExprCompToken {
    [string] $Definition
	[string] $TokType
	
	PrimitiveToken([string] $definition, [string] $tokType) {
		$this.Definition = $Definition
		$this.TokType = $tokType
	}
	
	consume([string] $text, [int] $offset) {
		Write-Host 'Consuming ExprCompToken'
	}
}

# This class represents an individual token.
# The 'subexpression' TokType in particular can be made of sub-tokens including other subexpressions,
# forming a hierarchical tree.
# Other types represent individual tokens.
class ExprCompTokenizedExpression : ExprCompToken {
	# A list of options, each of which will attempt a match to the passed definition.
	# For each option, 
	[List[List[ExprCompToken]]] $Options
	
	# The provided definition is for the root expression. An offset gives the index of the first character in this subexpression.
	# If the first character is a '<' or '[', this will parse until it finds the matching character.
	ExprCompTokenizedExpression([string] $definition, [string] $tokType, [int] $offset, [int] $depth)  : base($definition, $tokType) {
		if ($depth -ge 128) {
			throw 'Subexpression depth limit reached.'
		}
		
		$this.Definition = $definition
		$this.TokType = $tokType
		
		$this.MaxOccurences = 1
		
		if ($this.TokType -eq 'subexpression') {
			# Check what we're parsing.
			# That is, whether it's a root expression or not, and whether it is optional.
			if ($offset -eq -1) {
				$this.Optional = $false
				$this.Root = $this
				$this.Parent = $null
			}
			else {
				if ($definition[$offset] -eq '[') {
					$this.Optional = $true
				}
				elseif($definition[$offset] -eq '<') {
					$this.Optional = $false
				}
				else {
					throw "For token type 'subexpression', 'offset' parameter must be -1 (for the root expression) or point to a '<' or '[' character depending on whether it i9s optional."
				}
			}
			
			$this.Options = [List[ExprCompTokenizedExpression]]::new()
			
			#### State ####
			
			# Read characters since the last complete token.
			[string] $buffer = ''
			
			# Index of single-quote character that began the current string.
			# -1 means we are not in a string.
			[int] $string_start_i = -1
			
			#### Iteration ####
			
			[int] $total_iters = 0
			[int] $last_i = $null
			for ([int] $i = $offset; $i -lt $definition.Length;) {
				# Hard cap to prevent an infinite loop.
				$total_iters++
				if ($total_iters -eq 4096) {
					throw 'Subexpression iteration cap hit.'
				}
				
				# This is handy since the index is advanced an arbitrary amount determined by the branching path.
				# This statement detects when a branch is missing a thing to increment the index.
				if ($i -eq $last_i) {
					throw 'i value not updated.'
				}
				$last_i = $i
				
				[char] $character = $definition[$i]
				
				# Check if in string.
				if ($string_start_i -ne -1) {
					# Check for escape sequences.
					if ($definition.IndexOf('\n', $i, 2) -eq 0) {
						$buffer = $buffer + "`n"
						$i+=2
					}
					elseif($definition.IndexOf('\r', $i, 2) -eq 0) {
						$buffer = $buffer + "`r"
						$i+=2
					}
					elseif($definition.IndexOf('\t', $i, 2) -eq 0) {
						$buffer = $buffer + "`t"
						$i+=2
					}
					elseif($definition.IndexOf('\\', $i, 2) -eq 0) {
						$buffer = $buffer + '\'
						$i+=2
					}
					elseif($definition.IndexOf("\'", $i, 2) -eq 0) {
						$buffer = $buffer + "'"
						$i+=2
					}
					elseif($definition.IndexOf("\'", $i, 2) -eq 0) {
						$buffer = $buffer + '"'
						$i+=2
					}
					# Check for end of string.
					elseif ($character -eq $definition[$string_start_i]) {
						$string_start_i = -1
						$i++
					}
					# Append Chaaracter
					else {
						$buffer = $buffer + $character
						$i++
					}
				}
			}
		}
		else {
			$this.Options = $null
			$this.Label = $null
		}
	}
	
	consume([string] $text, [int] $offset) {
		Write-Host 'Consuming ExprCompTokenizedExpression'
	}
}