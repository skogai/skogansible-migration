# ZSH Completions

This directory contains shell completions for various tools.

## Large Completion Files

Some completion files are quite large (auto-generated):

- `_deno.zsh` (215KB, 2933 lines) - Deno runtime completions
- `_uv` (380KB, 4940 lines) - Python package manager completions
- `warp-cli.zsh` (150KB+) - Warp VPN client completions

## Regenerating Completions

These files can typically be regenerated using:

- **Deno**: `deno completions zsh > _deno.zsh`
- **uv**: `uv generate-shell-completion zsh > _uv`
- **GitHub CLI**: `gh completion -s zsh > _gh`

## Installation

These completions are automatically loaded by the zsh configuration in `zshrc`.

## Custom Completions

- `ast-grep.zsh` - AST-based code search tool
- Files in `completions/` subdirectory are standard zsh completion format
