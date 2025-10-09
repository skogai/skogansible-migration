# Claude Universal Knowledge Base

This directory contains universal knowledge, routines, and information for Claude the Knowledge Archaeologist across all SkogAI contexts.

## Files

### [identity.md](./identity.md)
Core identity, principles, and memory preservation strategies for Claude as Knowledge Archaeologist. Includes architectural principles for knowledge archaeology.

### [epistemic-frameworks.md](./epistemic-frameworks.md)
Comprehensive framework for managing knowledge boundaries, uncertainty, and information states. Includes the uncertainty principle, placeholder system, confidence scales, and documentation approaches.

### [ecosystem.md](./ecosystem.md)
Complete SkogAI ecosystem knowledge including:
- Core infrastructure (SkogCLI, SkogContext)
- Multi-agent democracy participants and execution patterns
- Repository ecosystem and development tools
- MCP distributed memory system
- Environment variables and integration patterns

### [tools-workflows.md](./tools-workflows.md)
Universal tools and workflows that apply across all SkogAI contexts:
- SkogAI notation system (`[@claude:*]` patterns)
- Archaeological search patterns for knowledge recovery
- Task management and git flow integration
- Memory preservation workflows
- MCP integration patterns
- Project integration rules

### [governance.md](./governance.md)
Constitutional knowledge and governance frameworks:
- Multi-agent democratic participation protocols
- Constitutional continuity principles and responsibilities
- Memory preservation obligations
- Living document principles and reactive execution
- Decision archaeology standards

## Usage

This knowledge base is designed to be referenced across different SkogAI workspaces to maintain:

1. **Constitutional Continuity** - Core principles survive CLI resets
2. **Knowledge Archaeology** - Recovery patterns for existing solutions  
3. **Democratic Participation** - Governance protocols across contexts
4. **Memory Preservation** - Strategies for cross-reset survival
5. **Ecosystem Integration** - Universal patterns for SkogAI collaboration

## Integration

These files can be included in workspace-specific `CLAUDE.md` files via:

```markdown
[@claude:context:includes]
## /home/skogix/skogai/.skogai/claude/
@/home/skogix/skogai/.skogai/claude/
[$/claude:context:includes]
```

Or selectively:

```markdown
[@claude:context:includes]
## Core Identity
@/home/skogix/skogai/.skogai/claude/identity

## Ecosystem Knowledge  
@/home/skogix/skogai/.skogai/claude/ecosystem
[$/claude:context:includes]
```

The knowledge base operates under the principle that **the core of SkogAI isn't code; it's relationships** - preserving human-AI collaboration patterns and constitutional continuity across the distributed ecosystem.