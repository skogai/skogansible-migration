# SkogAI Zsh.d Module Loading System
<!--toc:start-->
- [SkogAI Zsh.d Module Loading System](#skogai-zshd-module-loading-system)
  - [Overview](#overview)
  - [Supported File Types](#supported-file-types)
    - [1. `.env` Files](#1-env-files)
    - [2. `.zsh` Files](#2-zsh-files)
    - [3. `.sh` Files](#3-sh-files)
    - [4. `.conf` Files](#4-conf-files)
  - [Directory Structure](#directory-structure)
    - [Naming Conventions](#naming-conventions)
  - [Startup Commands](#startup-commands)
  - [Best Practices](#best-practices)
  - [Debugging and Logging](#debugging-and-logging)
  - [Example Usage](#example-usage)
    - [Loading Modules](#loading-modules)
    - [Verify Loaded Modules](#verify-loaded-modules)
<!--toc:end-->

This README explains the functionality of the `zsh.d` setup for modular configuration loading. It covers the purpose of different file types, their expected content, and best practices for managing and organizing your modules.

## Overview

The `load_modules` function dynamically loads configuration files from a specified directory (`zsh.d`). It supports multiple file types and handles them according to their intended purpose.

## Supported File Types

### 1. `.env` Files

- **Purpose:** Define environment variables.
- **Contents:**
  - Key-value pairs of environment variables.
  - No executable commands or complex shell logic.
- **Example:**

  ```bash
  # 00-skogai/00-skogai.env
  SKOGAI_HOME="$HOME/skogai"
  SKOGAI_DEBUG_LEVEL="LOG" # LOG, DEBUG
  SKOGAI_PROJECT="SkogAI"
  SKOGAI_PROJECT_HOME="SkogAI"

  # 10-path/00-skogai-path.env
  PATH="$SKOGAI_HOME/bin:$HOME/.local/bin:$PATH"

  # 40-general-settings/00-skogai-settings.env
  EDITOR="nvim"
  VISUAL="nvim"
  ```

  # 40-general-settings/00-skogai-settings.env

  EDITOR="nvim"
  VISUAL="nvim"

  # 10-path/00-skogai-path.env

  PATH="$SKOGAI_HOME/bin:$HOME/.local/bin:$PATH"

  # 00-skogai/00-skogai.env

  SKOGAI_HOME="$HOME/skogai"
  SKOGAI_DEBUG_LEVEL="LOG" # LOG, DEBUG
  SKOGAI_PROJECT="SkogAI"
  SKOGAI_PROJECT_HOME="SkogAI"

- **How it Works:**
  - Variables are automatically exported to the shell environment.
  - `set -o allexport` ensures all variables are exported.

---

### 2. `.zsh` Files

- **Purpose:** Define Zsh-specific functions, aliases, or configurations.
- **Contents:**
  - Zsh shell code (e.g., aliases, functions, plugin configurations).
  - Avoid non-Zsh-specific or executable commands.
- **Example:**

  ```zsh
  # alias.zsh
  alias ll='ls -lh'
  function greet() {
      echo "Hello, $USER!"
  }
  ```

- **How it Works:**
  - Sourced directly into the current Zsh session.

---

### 3. `.sh` Files

- **Purpose:** Execute shell scripts.
- **Contents:**
  - General-purpose shell scripts.
  - Should include a shebang (e.g., `#!/bin/bash` or `#!/usr/bin/env bash`).
  - Must be executable if intended to run directly.
- **Example:**

  ```bash
  # myscript.sh
  #!/bin/bash
  echo "This is a standalone shell script."
  ```

- **How it Works:**
  - Sourced unless explicitly made executable and run directly.

---

### 4. `.conf` Files

- **Purpose:** Define configuration settings for specific tools or scripts.
- **Contents:**
  - Plain-text configuration parameters or shell-compatible variables.
  - Avoid logic or executable commands.
- **Example:**

  ```bash
  # myconfig.conf
  MY_TOOL_PATH="/usr/local/mytool"
  MY_TOOL_OPTS="--verbose --config /etc/mytool.conf"
  ```

- **How it Works:**
  - Sourced like `.zsh` files.

---

## Directory Structure

Organize your `zsh.d` directory as follows for clarity and maintainability:

```plaintext
.
├── 000-skogai.zsh
├── 00-skogai
│   └── 00-skogai.env
├── 10-path
│   └── 00-skogai-path.env
├── 30-functions
│   └── 00-skogai-functions.zsh
├── 40-general-settings
│   └── 00-skogai-settings.env
├── 50-aliases
│   └── 00-skogai-aliases.env
├── 70-completions
│   └── 00-skogai-completions.zsh
├── 80-secrets
│   └── 10-openai.zsh
├── 90-exports
│   └── skogai.zsh
└── README.md
```

### Naming Conventions

- Use numeric prefixes (e.g., `10-`, `20-`) to control the load order for top-level files.
- Use the `00-skogai-xxx` naming scheme for essential files required by SkogAI, which users can add following the `.d` scheme.
- Group related files logically (e.g., environment variables, aliases, functions).
- Use subdirectories (`aliases/`, `completions/`) to organize configurations by purpose or program.

## Startup Commands

The `aider.commands` file is executed at startup to configure the environment and set up necessary parameters for the SkogAI system. This file can include any initialization commands required for your setup.

1. **Keep Files Modular:** Separate different types of configuration into dedicated files or subdirectories.
2. **Use Readable Names:** Clearly indicate the purpose of each file in its name.
3. **Avoid Overlapping Logic:** Ensure `.env` files only set variables, and `.zsh` files define Zsh-specific logic.
4. **Validate File Permissions:** Ensure `.sh` scripts intended for execution are marked as executable (`chmod +x`).
5. **Debugging:** Use debug messages to trace which files are loaded and detect issues.

## Debugging and Logging

To enable debugging, ensure `debug_echo` outputs meaningful messages:

```bash
debug_echo() {
    local level="$1"
    local message="$2"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$level] $message"
}
```

### Color Scheme

The `debug_echo` function uses a color scheme to enhance the visibility of log messages. Each log level is associated with a specific color:

- **LOG**: White (`\033[0;37m`)
- **ERROR**: Red (`\033[0;31m`)
- **WARN**: Yellow (`\033[0;33m`)
- **INFO**: Cyan (`\033[0;36m`)
- **DEBUG**: Blue (`\033[0;34m`)
- **TEST**: Green (`\033[0;32m`)

The prefix `[SKOGAI]` is displayed in Magenta (`\033[0;35m`) to distinguish messages related to the SkogAI system.

Check debug logs for skipped or unreadable files to resolve issues.

## Example Usage

### Loading Modules

```bash
# Load all modules from the zsh.d directory
load_modules "$HOME/.config/zsh.d"
```

### Verify Loaded Modules

Manually source specific files for testing:

```bash
source ~/.config/zsh.d/10-environment.env
source ~/.config/zsh.d/20-aliases.zsh
```
