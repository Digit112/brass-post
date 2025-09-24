# Brass-Post

Brass-Post is a command-line based, serverless, networked group messaging system.

## Command Usage

The following shows the usage of Brass-Post, including important flags. The application also has a built-in console with different functionality.

```
Usage:
Brass-Post -Listen
Brass-Post -AddKeyLoc <String> -IdentityName <String>
Brass-Post -KeyGen -IdentityName <String> [-FolderPath <String>]
Brass-Post -ExportUserData [-FilePath <String>] [-IncludeIdentityLoc]
Brass-Post -ImportUserData [-FilePath <String>] [-IncludeIdentityLoc]
```

### Parameters

| Flag                  | Description
| :-------------------- | :----------
| `-AddKeyLoc`          | Adds the passed path as a directory within which to search for identity keyfiles.
| `-ExportUserData`     | Exports the JSON configuration data stored within the file itself.
| `-FilePath`           | The file to export to/import from, defaults to "brass-post-data.json"
| `-FolderPath`         | The folder to output generated files to. Default is the current directory.
| `-IdentityName`       | The display name of the identity being created.
| `-ImportUserData`     | Exports the JSON configuration data stored within the file itself.
| `-IncludeIdentityLoc` | Includes the path to identity keyfiles in an export or import, not the keys themselves.
| `-KeyGen`             | Generates a new identity
| `-Listen`             | Opens known chats and launches into the Brass-Post console.

## The Brass-Post Console

The Brass-Post Console is how you actually use the application to interact with others.
Type text into the prompt at the bottom of the console and hit enter to send, or shift+enter for a newline.

Tap the '/' key to toggle command mode on and off.

### Identity

Multiple parameters take an "Identity". This can be an IPv4 or IPv6 address, or a domain name, the nickname of a known user, or a prefix or suffix of the public key of a known user. In all cases, a port may be appended to the end, preceeded by a colon.

### Join-Channel

```
/Join-Channel [-Name] <String>
```

Connects to the channel with the specified name. The channel must have been previously persisted either with `-ImportUserData` or `/Get-Channels`, or created with `/New-Channel`

### Get-Channels

```
/Get-Channels -Identity <Identity>
```

Requests a copy of this peer's channels, which are persisted between sessions. The peer can be specified as an IPv4 or IPv6 address or domain. A port may be added, preceeded by a colon as in `127.0.0.1:27277` or `server.mydomain:27277`. With an IPv6 address with a port, the address must be enclosed in square brackets as in `[::1]:27277`. `27277` is the default port.

### New-Channel

```
/New-Channel [-Name] <String>
```

Creates and persists a new channel. 

### View-User

```
/View-User [-Identity] <nickname | partial pub key> [-Channel <channel>]
```

Shows details about the selected user such as their past nicknames (as known to this client), their public key















