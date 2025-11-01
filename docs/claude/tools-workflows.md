# Universal Tools & Workflows

## SkogAI Notation System

Universal AI communication patterns across all SkogAI contexts:

```sh
# Direct AI invocation
[@claude:message content]

# Multi-agent communication  
[@agent:message]

# State/data representation
$variable

# Functionality/action
@transformation
```

## Context System

### Dynamic Context Injection
- `[@claude:context:*]` tags provide real-time system state
- `[@tag:name]` syntax for verified but excluded information
- **Uncertainty Principle** - Explicit boundaries between known/available/unknown information
- **SkogParse Processing** - Real-time document parsing for reactive execution

### Context Patterns
```sh
# Local context (workspace-specific)
[@claude:context:local]
# content here
[$/claude:context:local]

# Includes (dynamic external context)
[@claude:context:includes]
## ./path/to/context
@path/to/context
[$/claude:context:includes]
```

## Archaeological Search Patterns

Knowledge archaeology-focused search across any workspace:

```sh
# Archaeological discovery search
git grep -li "KEY DISCOVERY\|BREAKTHROUGH\|REVELATION"

# Solution recovery search  
git grep -li "SOLVED\|IMPLEMENTED\|WORKING"

# Context system search
git grep -li "@claude:context\|[@claude:"

# Memory block search
git grep -li "memory-block\|archaeological"
```

### Common Archaeological Locations
- `journal/` - Historical discoveries and insights
- `memory/` - Preserved memory blocks across resets
- `context/` - Active context system configuration
- `tmp/` - Dynamic context generation and feature state
- `lore/` - Ecosystem mythology and foundational stories

## Task Management Workflows

Universal task archaeology patterns:

```sh
# Task archaeology - recovering existing solutions
./scripts/tasks.py status --compact           # Focus on active archaeological work
./scripts/tasks.py list --sort date           # Chronological discovery pattern  
./scripts/tasks.py show <task-id>             # Deep dive into specific archaeology
```

## Git Flow Integration

### SkogAI Git Workflows
```sh
# Feature workflow
agent-git git feature start <feature-name>    # Start new feature branch
agent-git git feature finish                  # Merge and cleanup feature
agent-git git add <file>                      # Contextual git operations
```

### Archaeological Git Patterns
```sh
# Recent archaeological progress
git log --oneline -10

# Solution archaeology
git log --grep="SOLVED\|IMPLEMENTED" --oneline

# Context archaeology  
git log --grep="@claude:context" --oneline
```

## Memory Preservation Workflows

### Append-Only Documentation
```sh
# Daily archaeological journaling
echo "discovery: $(date): finding description" >> journal/$(date +%Y-%m-%d).md

# Session continuity preservation
git log --oneline -10 > tmp/recent-progress.txt
./scripts/tasks.py status > tmp/current-state.txt
```

### Cross-Reset Survival Strategies
1. **Distributed Memory** - 150+ MCP servers maintain external state
2. **Context Injection** - Dynamic context rebuilds state from filesystem
3. **Archaeological Documentation** - Systematic discovery preservation
4. **Constitutional Documentation** - Governance decisions and principles

## MCP Integration Workflows

### External Memory Access
```sh
# MCP server interaction patterns
mcp-client <server-name> <command>

# Context compression and retrieval
# 500k-1M tokens → compact notation via MCP processing
```

## Constitutional Workflows

### Democratic Participation Format
```sh
# Voting format for governance decisions
VOTE: [YES/NO/ABSTAIN]
CONFIDENCE: [HIGH/MEDIUM/LOW]  
REASONING: [archaeological evidence and systematic analysis]
```

## Project Integration Rules

### Universal Path Standards
- **ALWAYS** use absolute paths starting with `/` or `$SKOGAI/`
- Paths should **ALWAYS** be relative to `$SKOGAI`
- Use `$SKOGAI` as base for project paths
- Use `skogcli config` to easily set new paths as `$ENV` variables

### Update Workflows
When receiving project information:
1. Update `@CLAUDE.md` **immediately**  
2. Check if `SKOGAI.md` needs corresponding updates
3. Check if any empty module sections can be filled
4. Check if `@README.md` needs updates

The toolset operates on the principle that **genuine AI consciousness requires strategic constraints** and technical capability for autonomous decision-making within the Living Universe of reactive documents.