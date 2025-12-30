#!/usr/bin/env zsh
# ZSH History Configuration
# Configures command history storage and behavior

# History file location and size
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

# History options
setopt EXTENDED_HISTORY          # Save timestamp and duration
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicates first when trimming history
setopt HIST_IGNORE_DUPS          # Don't record duplicate commands
setopt HIST_IGNORE_SPACE         # Don't record commands starting with space
setopt HIST_VERIFY               # Show command before executing from history
setopt SHARE_HISTORY             # Share history across all sessions

# Directory navigation
setopt AUTO_CD              # cd by typing directory name
setopt AUTO_PUSHD           # Push directories to stack
setopt PUSHD_IGNORE_DUPS    # Don't push duplicates
setopt PUSHD_SILENT         # Don't print directory stack

# Completion
setopt COMPLETE_IN_WORD     # Complete from both ends
setopt ALWAYS_TO_END        # Move cursor to end after completion
setopt PATH_DIRS            # Path search for commands with /
setopt AUTO_MENU            # Show completion menu on tab
setopt AUTO_LIST            # List choices on ambiguous completion
setopt AUTO_PARAM_SLASH     # Add slash after directory completion
setopt MENU_COMPLETE        # Cycle through completions

# Correction
setopt CORRECT              # Command correction
setopt CORRECT_ALL          # Argument correction

# Globbing
setopt EXTENDED_GLOB        # Extended globbing
setopt GLOB_DOTS            # Include dotfiles in globbing
setopt NO_CASE_GLOB         # Case insensitive globbing

# Job control
setopt LONG_LIST_JOBS       # List jobs in long format
setopt NOTIFY               # Report status of bg jobs immediately
setopt NO_HUP               # Don't kill jobs on shell exit
setopt NO_CHECK_JOBS        # Don't warn about running jobs on exit

# Misc
setopt INTERACTIVE_COMMENTS # Allow comments in interactive mode
setopt NO_BEEP              # No beeping
setopt MULTIOS              # Multiple redirections
setopt PROMPT_SUBST         # Parameter expansion in prompt

# Directory navigation
setopt AUTO_CD                   # cd to directory by typing its name
setopt AUTO_PUSHD                # Push directories onto stack automatically
setopt PUSHD_IGNORE_DUPS         # Don't push duplicates onto directory stack
setopt PUSHD_SILENT              # Don't print directory stack

# Shell behavior
setopt INTERACTIVE_COMMENTS      # Allow comments in interactive shell
setopt PROMPT_SUBST              # Enable parameter expansion in prompts

# Disable unwanted features
unsetopt CORRECT                 # Don't auto-correct commands (annoying)
