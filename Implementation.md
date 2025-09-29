# Brass-Protocol

The protocol used by brass-post is to send UTF-8 encoded JSON to a message's recipient over TCP. The keys are `method`, `content`, and `identity`.


# Command Definition Syntax

Commands - in the Brass-Post console *and* while using flags when evoking Brass-Post - use a custom, recursive syntax something like ABNF but using different symbols. Square brackets `[]` enclose optional text, while angle brackets `<>` enclose one or more options delimited by the pipe character `|`, like so:

```
New-Animal [-Species] <Dog | Cat | Fish>
```

An angle-bracket enclosed sequence is called a subexpression. In all commands, the first flag is optional since it can always be deduced positionally. In this case, the *parameter* to that flag is *not* optional, since it is not enclosed in square brackets. We see that there are three options for what animal to make. An option can be a type or literal text, since none of these are types, they must all be literal text. In ambiguous cases, your text can be enclosed in single-quotes like so:

```
Weird-Command <'Integer' | Integer>
```

The above command can take the literal word "Integer" or an *actual* integer like 27 or 99.

Regardless of the context of a literal string, it is always trimmed of whitespace on each end.

## Arrays

An ellipses may appear at the end of a subexpression list, optionaly followed by an integer. In this case, the contents of the list may repeat up to the number of times specified in the ellipses, like so

```
Add-Numbers <Float...>
```

In this case, the user can specify any number of floats. They must specify at least one. If you want to allow the user to specify none, you must enclose the angle-brackets in square-brackets to make them optional.

```
Make-Trio <String String...3>
```

In this case, they may specify up to three pairs of strings.

## Subexpression Labels

A subexpression may begin with a label followed by a colon:

```
New-Animal <species: [-Species] <Dog | Cat | Fish>>
```

This is a named subexpression. Subexpression names do not need to be unique.

## User Entry & Help

Wherever multiple consecutive types are expected, the user must delimit them with whitespace, which may include carriage-return or newline characters. Anywhere the user would like to enter text with spaces, they must enclose it in single-quotes or double-quotes, which are treated identically on the Brass-Post command line.

For entering arrays, the user must delimit each value with a comma.

The subexpression `<String String...>`, for example, requests an array of pairs of strings.

The user could enter `First Second, Third Fourth`. This is an array of two pairs of strings. It is equivalent to `"First" "Second", "Third" "Fourth"`. The spaces between them could be any whitespace, it could also include carriage returns or newlines.

The user could also enter `"First, Second" "Third, Fourth"` as well. This is only a single pair of strings, however. The commas are embedded in the strings and are not interpreted as delimiting repetitions of an item.

Strings can include the following escape sequences which have their usual meaning:
`\n`, `\r`, `\t`, `\'`, `\"`, `\\`. Any backslash not included in one of these sequences is interpreted as a literal backslash.

### Ambiguous definitions

An expression such as `<Integer [Integer]...> [Integer]` is ambiguous. For example, given the user text `1 2, 3 4, 5 6`, Is the "6" the second parameter of the last entry in the array, or is it the final integer at the end? It is impossible to know for sure. The parser does not take pains to detect these situations, they will compile without error, but in practice the parser is greedy and will always consume as much text as possible while attempting to read a token. So the 

Some situations are ambiguous,

## Tips & Edge Cases

### Whitespace in Command Definitions

Whitespace can be thought of as the concatenation operator. Anywhere two tokens are separated by any whitespace in a command definition, they can be separated by any other whitespace in the actual command. So a command author can write:

```
My-Command
    [-Flag1 String]
    [-Flag2
        <String Integer...>
    ]
```

The user could write:

```
My-Command -Flag1 "Some Text" -Flag2 Name1 12, Name2 45
```

### Recursive Evaluation

Angle-braces are just subexpressions and they are evaluated recursively with the same exact code that evaluates the whole command. So, you can (and should) give the whole command a label, or add a pipe to delimit different command usages, or even (for some reason) add ellipses to the end to allow repetition.

```
command_label:
My-Command -UsageStr [<name: -Name <String>>] |
My-Command -UsageInt [<name: -Name <Integer>>]
```

The above command has two usages, one for string input and one for integer input. The command's layout requires that the user 

### Empty Subexpression Error

It is an error for an angle-bracket closed expression to match nothing. Some examples below will all fail to compile:

```
<>
<[Something]>
<[Something]...>
<' '>
<' ' | Something>
```

Recall that strings are always trimmed.

# Using the CommandLibrary

The CommandLibrary accepts "ParsedExpression" types and matches them to the user's input. Such a type is generated from a string with the syntax decribed in the preceeding section. Internally, each begins by generating a TokenizedExpression and working off of that.

Each 

# Using the Commands

## Help Output

The `help()` function on a `ParsedExpression` returns a string with a line for every option in that root expression.
For each such option, the `define()` function is called, and the outputs are concatenated.

The `define()` function 

