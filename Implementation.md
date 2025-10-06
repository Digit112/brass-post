# Brass-Protocol

The protocol used by brass-post is to send UTF-8 encoded JSON to a message's recipient over TCP. The keys are `method`, `content`, and `identity`.


# Command Definition Syntax

Commands - in the Brass-Post console *and* while using flags when evoking Brass-Post - use a custom, recursive syntax something like ABNF but using different symbols.

An expression consists of a sequence of tokens separated by whitespace. They are completely case-insensitive except within double-quote enclosed literals.

## String Literals

The pattern `A Brown Dog` has three tokens, string literals, which we have chosen to separate with spaces. However, any whitespace between them would have been equivalent. Text to be matched can have any sequence of tabs, spaces, newlines, and so on between these three words and it will match the pattern. Also, they are case-insensitive.

So, for an example:

```
a
	brown
		DOG
```

is an equivalent definition and - as it happens - also matches against our original definition (and itself).

## Types

The literal text `Integer`, `Float`, `String`, and `Bool` are keywords that correspond to typenames. Where one is expected, the matched text's input is read off and converted to the appropriate type. For example, the pattern `Integer Integer Integer` looks similar to the first pattern in that it consists of three whitespace-separated tokens of letters, but is quite differnt. It will match three whitespace-separated decimal numbers, like for example `12 7 2`.

## Quoted String Literals

Quoted literals are text enclosed by single-quotes `''` or double-quotes `""`. They are useful to match whitespace exactly, to match cased text, or to match literal text that would otherwise be interpreted as a type name.

For example, the pattern `'A Brown Dog'` contains only one token, which has two spaces, and those spaces cannot be substituted for arbitrary whitespace like before. They are matched literally. However, the match is still case-insensitive. For a case-sensitive match, prefix the string with an `s` like `s'A Brown Dog'`. This pattern will ONLY match exactly the text `A Brown Dog`. Nothing else.

Quoted literals also allow you to match keywords like `Integer` and `Bool`.

Quoted literals also may include the following escape sequences which have their usual meaning: `\n`, `\r`, `\t`, `\'`, `\"`, `\\`. Any backslash not included in one of these sequences is interpreted as a literal backslash. This is actually the same functionality available to the user when entering a string.

## Arrays

An ellipses may appear at the end of a subexpression, optionally followed by an integer. In this case, the contents of the list may repeat up to the number of times specified in the ellipses, like so

```
Add-Numbers <Float...>
```

In this case, the user can specify any number of floats. They must specify at least one. If you want to allow the user to specify none, you must make the subexpression optional.

```
Make-Trio <String String...3>
```

In this case, they may specify up to three pairs of strings.

### Operator Precedence

The array `...` operator has the lowest precedence of any operator, even lower than the concatatenation operator which is just any whitespace sequence outside of quotes.

```
# A list of Integers and Bools all mixed together.
Integer | Bool...

# A list of all integers or all bools.
<Integer...> | <Bool...>

# A list of Bools or a single integer.
Integer | <Bool...>

# A list of Integer-Bool pairs.
Integer Bool...

# A list of integers followed by a list of Bools.
<Integer...> <Bool...>

# An integer followed by a list of Bools.
Integer <Bool...>
```

Note above how the angle brackets can be used for grouping, similar to the use of parentheses in arithmetic.



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

An expression such as `<Integer [Integer]...> [Integer]` is ambiguous. For example, given the user text `1 2, 3 4, 5 6`, Is the "6" the second parameter of the last entry in the array, or is it the final integer at the end? It is impossible to know for sure. The parser does not take pains to detect these situations, they will compile without error, but in practice the parser is greedy and will always consume as much text as possible while attempting to read a token. So the 6 will be interpreted as being part of the array. In this case, it is not possible to match anything to the last integer.

Another example is `<String...> | <Integer...>`. A list of integers matches both options here. With this situation, the parser again is greedy, choosing whichever option consumes the most text. (If this causes an error down the line, the parser will backtrack and try matching the other option.)

If the options are the same length, it chooses whichever is further left in the definition, so order matters! Anything matched by this pattern will be considered an array of strings. If we swap the order, we get `<Integer...> | <String...>`, which has interesting characteristics. It will match any list of integers, but if a string is found anywhere in the list then it all suddenly becomes a list of strings.

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

Subexpressions are evaluated recursively with the same exact code that evaluates the whole expression. So, you can (and should) give the whole command a label, or add a pipe to delimit different command usages, or even (for some reason) add ellipses to the end to allow repetition.

```
command_label:
My-Command -UsageStr [<name: -Name <String>>] |
My-Command -UsageInt [<name: -Name <Integer>>]
```

The above command has two usages, one for string input and one for integer input. The command's layout requires that the user explicitly specify (with the flag name) which they are using.

### Empty Subexpression Error

It is an error for the whole expressions or any subexpression to match notthing (unless it is optional). Some examples below will all fail to compile:

```
<>
[Something]
[Something]...
<''>
<'' | Something>
```

# Using the CommandLibrary

The CommandLibrary accepts "ParsedExpression" types and matches them to the user's input. Such a type is generated from a string with the syntax decribed in the preceeding section. Internally, each begins by generating a TokenizedExpression and working off of that.

Each 

# Using the Commands

## Help Output

The `help()` function on a `ParsedExpression` returns a string with a line for every option in that root expression.
For each such option, the `define()` function is called, and the outputs are concatenated.

The `define()` function 

