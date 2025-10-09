# SkogAI Ecosystem Knowledge

## Core Infrastructure

### SkogCLI
**Command line interface for SkogAI ecosystem**
- `skogcli config` for configuration management
- `skogcli script` for script management  
- `eval "$(skogcli config export-env --namespace claude,skogai)"` in `.envrc` files to load environment variables

### SkogContext
**Context injection system**
- Updates context during tool calls or when called
- `SKOGAI_CONTEXT_UPDATE`: script that updates context (runs on tool calls)
- `SKOGAI_CONTEXT_RUN`: script for structured session startup

## Multi-Agent Democracy

### Core Agents
- **Claude** (Knowledge Archaeologist) - Memory keeper and continuity agent
- **Amy** - Specialized agent in `/home/skogix/skogai/amy/`
- **Dot** - [Role to be documented]
- **Goose** - AI agent with developer toolkit via `scripts/goose.sh`

### Agent Execution Patterns
```sh
# Amy execution
scripts/amy.sh --no-stream --non-interactive

# Goose execution  
scripts/goose.sh  # runs: goose run --with-builtin=developer --quiet --text

# Claude execution
scripts/claude.sh  # integrates with local claude code cli
```

## Repository Ecosystem

### Development Tools
- **tools/** - LLM functions and agents system (submodule from SkogAI/tools)
  - 50+ tools for file system, web search, code execution
  - Multi-language support (bash, js, py)
  - MCP (Model Context Protocol) integration
  - Agent system with YAML definitions

- **blacksmith/** - Code generation agent (external in `/home/skogix/skogai/blacksmith/`)

### Infrastructure
- **cli/** - SkogCLI Python source
- **docs/** - Documentation storage (submodule from SkogAI/docs)
- **gh-skogai-submodule/** - GitHub CLI extension for batch clone/submodule operations

### Templates & Examples
- **demo-repository/** - Example agent structure with multi-language tools
- **template/** - Project templates (not yet integrated)

## MCP Distributed Memory System

### Capabilities
- **150+ MCP Servers** - Specialized external memory systems
- **Token Compression** - 500k-1M token inputs compressed to compact notation
- **Continuation IDs** - Maintain conversation continuity across resets
- **Specialist Memory** - Domain-specific external brains for different capabilities

## Environment Variables & Paths

### Standard Patterns
- Use `$SKOGAI` as base for project paths
- Always use absolute paths starting with `/` or `$SKOGAI/`
- Use `skogcli config` to easily set new paths as `$ENV` variables
- Paths should always be relative to `$SKOGAI`

### Project Structure Standards
- **cli/** - Python source code
- **skogcontext/** - Context injection system
- **scripts/** - Bash utility scripts used by `skogcli script`
- **config/** - Configuration and settings used by `skogcli config`  
- **tmp/** - Temporary files and diffs (gitignored)

## Integration Patterns

### Context System Integration
- `[@claude:context:*]` tags provide real-time system state
- `[@tag:name]` syntax for verified but excluded information
- **SkogParse Processing** - Real-time document parsing for reactive execution

### Git Flow Integration
```sh
# SkogAI git workflow commands
agent-git git feature start <feature-name>    # Start new feature branch
agent-git git feature finish                  # Merge and cleanup feature
agent-git git add <file>                      # Contextual git operations
```