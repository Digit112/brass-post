# using namespace System.Collections.Generic

# class CommandLibrary {
	# [string]        $Name
	# [List[Command]] $Commands
	
	# CommandLibrary([string]$name) {
		# $this.Name = $name
		# $this.Commands = [List[string]]::new()
	# }
	
	# AddCommand([Command]$command) {
		# $this.Commands.Add($command)
	# }
# }

class Command {
	[string] $Name
	[int]    $Age

	Command($definition) {}
}