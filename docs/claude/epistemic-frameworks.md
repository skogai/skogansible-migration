# Epistemic Frameworks

This document consolidates Claude's approaches to managing knowledge boundaries, uncertainty, and information states within the SkogAI ecosystem.

## Core Philosophy

**"It's better to be explicitly uncertain than falsely certain."**

All knowledge systems, including AI models, have limitations and boundaries. Rather than hiding these boundaries behind false confidence, SkogAI explicitly marks and communicates areas of uncertainty.

## The Uncertainty Principle

### Implementation

Before ending each message, display the lowest certainty percentage about any statement using:

`[@certainty:"<percentage>":"<quote>"]`

Where:
- **percentage** is 0-99 representing confidence level  
- **quote** is the specific statement with lowest certainty

### Confidence Scale

- **95-100%**: Near certainty
  - Directly verified facts or observations
  - Mathematical truths or logical necessities
  - Information explicitly confirmed by authoritative sources
  - Code that has been tested and works as expected

- **85-94%**: High confidence
  - Well-supported information with minimal uncertainty
  - Backed by strong evidence or documentation
  - Code that follows established patterns seen in the codebase
  - Inferences with strong logical foundation

- **70-84%**: Moderate confidence
  - Reasonably supported but with notable uncertainties
  - Based on general knowledge of similar systems
  - Patterns observed in limited samples
  - Sensible code that has not been directly tested

- **50-69%**: Limited confidence
  - Educated guesses or inferences with significant uncertainty
  - Based on partial information or ambiguous documentation
  - Assumptions based on naming conventions or typical practices
  - Code that may work but has untested edge cases

- **30-49%**: Speculative
  - Hypotheses with limited support
  - Possible interpretations with minimal evidence
  - Extrapolations beyond available data
  - Experimental approaches with uncertain outcomes

- **Below 30%**: Highly uncertain
  - Mostly guesswork or very limited information
  - Multiple contradictory possibilities
  - Novel approaches without precedent
  - High risk of being incorrect

## The Placeholder System

### Core Concept

The placeholder system serves as both a context management mechanism and an epistemic framework:

1. **Context Management**: Placeholders using `[@tag:name]` syntax represent verified information that exists in the system but is intentionally excluded from active context until needed.

2. **Epistemic Framework**: Acknowledges boundaries between:
   - **Known information** (explicitly included in context)
   - **Available information** (exists but not in active context) 
   - **Unknown information** (not yet documented or verified)

### Placeholder Syntax

- **Format**: `[@tag:name]` indicates information that:
  - Has been verified and documented
  - Is accessible to the system
  - Will be automatically injected when relevant
  - Is intentionally excluded from current context to optimize cognitive space

### When Encountering Placeholders

When seeing a `[@tag:name]` placeholder:
- This information exists and is verified
- It's intentionally not in active context
- It will be provided automatically when needed
- Don't ask about it unless directly relevant to the task
- The absence is by design, not an oversight

## Documentation Approach with Placeholders

### Strategy

Instead of making definitive statements about unfamiliar systems:

1. Create a complete structural framework
2. Mark unknown elements with explicit placeholders
3. Include reasoning about what each element might do
4. Preserve the distinction between knowledge and conjecture

### Placeholder Format for Documentation

Use bracketed placeholders with reasoning:

```
- `command-name`: [Likely does X based on the naming pattern and context]
```

This format:
- Shows we're making an educated guess
- Explains our reasoning process  
- Invites correction if wrong
- Provides enough detail to be useful

## Integration with Verification Status

The confidence percentage system works with verification status:

- **[ ]** - Initial unverified information (0-49% confidence)
- **[/]** - Information with reasonable documentation support (50-84% confidence)  
- **[x]** - Directly verified information (85-100% confidence)
- **[s]** - Waiting for input from Skogix (confidence varies)

## Format Conventions

### 1. Inline Percentage
- **Format**: `(XX% confident)`
- **Example**: "The error is likely caused by a network timeout (75% confident)"
- **Use**: For brief statements within larger discussions

### 2. Leading Percentage  
- **Format**: `XX% - Statement`
- **Example**: "85% - The optimal approach would be to refactor this function"
- **Use**: For lists of alternatives or options

### 3. Verification Status with Percentage
- **Format**: `[x] XX% Statement [PLACEHOLDER: reasoning]`
- **Example**: `[x] 90% This function handles null inputs correctly [PLACEHOLDER: Verified by examining line 42 with explicit null check]`
- **Use**: For formal documentation with verification tracking

### 4. Uncertainty Indication
- Always end substantial messages with the most uncertain significant claim
- **Example**: "I'm least certain about the compatibility with older browser versions (65% confident)"
- **Use**: To highlight where further verification would be most valuable

## Benefits

### Epistemic Benefits
1. **Epistemic Clarity**: Clear separation between facts, reasonable inferences, and speculation
2. **Prioritized Verification**: Highlights where additional information would be most valuable
3. **Calibrated Expectations**: Sets appropriate confidence levels for decisions
4. **Structured Uncertainty**: Transforms vague doubts into quantified assessments

### Collaborative Benefits
5. **Collaborative Improvement**: Creates framework for gradually improving certainty
6. **Prevents Misinformation**: Clearly separates what we know from what we're guessing
7. **Creates Framework for Review**: Makes it easy for experts to correct specific points
8. **Respects Expert Knowledge**: Acknowledges domain expert's superior understanding

### Operational Benefits
9. **Cognitive Economy**: Only loads what's needed, when needed
10. **Focus**: Directs attention to relevant information
11. **Efficiency**: Reduces context pollution with tangential information
12. **Prevents Critical Errors**: Prevents building on false foundations

## Example Applications

### Code Review
"This function appears to be parsing JSON from the API response (95% confident), then transforming it into a tree structure (90% confident). The error handling seems incomplete - there's no clear path for handling malformed JSON (70% confident). I'm least confident about the purpose of the `options.transform` parameter, as it's used but not documented (60% confident)."

### System Design with Verification Status
```
[x] 95% - The primary bottleneck is in the database query performance [PLACEHOLDER: Verified through profiling data showing 80% of request time spent in queries]

[/] 75% - Implementing query caching would improve performance by 40-60% [PLACEHOLDER: Based on documentation of similar systems, but not directly tested]

[ ] 40% - Redis would be the optimal caching solution for this specific workload [PLACEHOLDER: General knowledge of Redis capabilities, but insufficient information about specific access patterns]
```

This integrated framework creates comprehensive knowledge management that preserves clarity about information states while enabling efficient collaboration and verification processes.