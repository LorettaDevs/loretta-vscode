# Loretta VSCode

## Features

A really barebones language server for lua/glua with the following features:
- Semantic Syntax Highlighting
- Autocomplete
- Go To Definition
- Code Formatting

## Known Issues

- Currently autocomplete does not offer known library methods (like `string.gsub` and etc.).
- Currently there is no support for autocomplete or go to definition for tables.
- Currently there is no support for code formatting customization.
- Code formatting is a bit weird currently.

## Release Notes
### v0.0.4
#### Fixed
- Fixed parameter names not being marked as readonly when they are.
- Fixed implicit `self` parameter not existing on methods.
- Fix file-level `arg` parameter being wrongfully added as `args`.
- Fix parameters and `for` variables not having their declaration highlighted when the caret is on a reference to them.
- Fix implicit variables not being declared as readonly when they don't have a declaration (like `self`).
#### Added
- Added semantic syntax highlighting support for function names.
- Added "Go To References" support for variables and goto labels.
#### Changed
- Write log files to temp folder instead of project directory.