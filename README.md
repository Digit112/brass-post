# Brass-Post

Brass-Post is a command-line based, serverless, networked group messaging system.

The intended workflow is for the user to enter the console and join a chat. From then on, they interact by sending messages and interacting with existing messages.

## Command Usage

The following shows the usage of Brass-Post, including important flags. The application also has a built-in console with different functionality.

```
Usage:
Brass-Post -Console
Brass-Post -AddKeyLoc <String> -IdentityName <String>
Brass-Post -KeyGen -IdentityName <String> [-FolderPath <String>]
Brass-Post -ExportUserData [-FilePath <String>] [-IncludeIdentityLoc]
Brass-Post -ImportUserData [-FilePath <String>] [-IncludeIdentityLoc]
```

### Parameters

| Flag                  | Description
| :-------------------- | :----------
| `-AddKeyLoc`          | Adds the passed path as a directory within which to search for identity keyfiles.
| `-Console`            | Launches into the Brass-Post console.
| `-ExportUserData`     | Exports the JSON configuration data stored within the file itself.
| `-FilePath`           | The file to export to/import from, defaults to "brass-post-data.json"
| `-FolderPath`         | The folder to output generated files to. Default is the current directory.
| `-IdentityName`       | The display name of the identity being created.
| `-ImportUserData`     | Exports the JSON configuration data stored within the file itself.
| `-IncludeIdentityLoc` | Includes the path to identity keyfiles in an export or import, not the keys themselves.
| `-KeyGen`             | Generates a new identity

## The Brass-Post Console

The Brass-Post Console is how you actually use the application to interact with others.
Type text into the prompt at the bottom of the console and hit enter to send, or shift+enter for a newline.

Tap the '/' key to toggle command mode on and off.

### Identities

Multiple parameters take an "Identity". This can be an IPv4 or IPv6 address, or a domain name, the nickname of a known user, or a prefix or suffix of the public key of a known user. In all cases, a port may be appended to the end, preceeded by a colon.

### Join-Channel

```
/Join-Channel <[-Name] <String> | -Identity <Identity>>
```

Connects to the channel with the specified name. The channel must have been previously persisted either with `-ImportUserData` or `/Get-Channels`, or created with `/New-Channel`

### Get-Channels

```
/Get-Channels [-Identity] <Identity>
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

## Taglines

Taglines are up to 64 characters long and show when Brass-Post starts up.

```
/Add-Tagline [-Tagline] <string> [-Shared]
```

Adds a tagline with a chance of showing on startup. If `-Shared` is included, taglines will sometimes be transmitted alongside normal messages and commands, and might start showing up on others' systems - *with your name on them*.

```
/Toggle-Tagline-Sharing
```

Toggles tagline sharing on or off. If it is off, your system will not share any taglines, nor disable taglines that were shared with you.

```
/List-Taglines
```

Lists all taglines on your system.

```
1. /Delete-Tagline -AllDefaults
2. /Delete-Tagline [-Index] <integer>
```

Usage 1. Delete all taglines that are included by default. Can't be undone, stupid.

Usage 2. Deletes the indexed tagline. Get the index from `/List-Taglines`.