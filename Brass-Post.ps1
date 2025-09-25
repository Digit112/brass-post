# Brass-Post is a command-line based, serverless networked group messaging system.

# Before running this script for the first time, an administrator must changee the execution policy:
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

# The comments below contains JSON-encoded configuration information such as user identity, connection info, emoji, and so much more.
# Don't read/edit it directly! Use the -ExportUserData and -ImportUserData flags instead.
# BRASS POST USERDATA {"key": []}

using namespace System.Console
using namespace System.Math
using namespace System.Collections.Generic

. .\CommandLibrary.ps1

# Load userdata
$userdata = @{}
$userdata_delim = "# BRASS POST USERDATA "
$source_code = Get-Content $PSCommandPath
foreach ($line in Get-Content $PSCommandPath) {
	if ($line.StartsWith($userdata_delim)) {
		$userdata = $line.SubString($userdata_delim.Length) | ConvertFrom-Json
		break
	}
}

# Add necessary structure to userdata if it is missing.
if (($userdata | Get-Member -Name 'identities') -eq $null) {
	$userdata | Add-Member -Name 'identities' -Value @() -MemberType NoteProperty
}

# Stores messages in the current chat.
$messages = [List[PSCustomObject]]::new()

function Draw {
	# Draw messages
	# TODO: Multiline support
	for ($msg_i = 0; $msg_i++; $row -lt [Math]::Min($messages.Count, [Console]::WindowHeight - 2)) {
		$message = $messages[$msg_i]
		
		[Console]::SetCursorPosition(0, [Console]::WindowHeight - 2)
		[Console]::Write($message.author)
	}
}

while ($true) {
	if ([Console]::KeyAvailable) {
		$keyInfo = [Console]::ReadKey($true)
		Write-Host "'$($keyInfo.Key)'"
	}
}

# [System.Console]::SetCursorPosition(1, 2)
# [System.Console]::Write("Hello Cursor!")

# while ($true) {
    # if ([System.Console]::KeyAvailable) {
        # $keyInfo = [System.Console]::ReadKey($true)
		
		# Write-Host "'$($keyInfo.Key)'"

        # # Check for Ctrl+C
        # if (($keyInfo.Modifiers -band [System.ConsoleModifiers]::Control) -and ($keyInfo.Key -eq 'C')) {
            # Write-Host "`nDetected Ctrl+C. Exiting..."
            # break
        # }
        
        # # Check for F1
        # if ($keyInfo.Key -eq 'F1') {
            # Write-Host "`nHelp key (F1) pressed."
            # # Your help function or code goes here
        # }
    # }
    # # Optional: Add a delay to reduce CPU usage
    # Start-Sleep -Milliseconds 10
# }