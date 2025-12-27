#!/bin/zsh

# Set SKOGAI_HOME to ~/skogai if not already set
: ${SKOGAI_HOME:="$HOME"}

# source "$SKOGAI_HOME/zsh.d/00-skogai/00-skogai.env"

load_modules() {
    local module_dir="$1"
    if [[ -d "$module_dir" ]]; then
        debug_echo "DEBUG" "Loading modules from directory: $module_dir"

        # Enable nullglob to avoid errors when no matches are found
        setopt nullglob

        # Use a recursive glob to include files from subdirectories
        for module_file in "$module_dir"/**/*.conf "$module_dir"/**/*.sh "$module_dir"/**/*.zsh "$module_dir"/**/*.env; do
            if [[ -r "$module_file" ]]; then
                if [[ "$module_file" == *.env ]]; then
                    debug_echo "DEBUG" "Exporting variables from: $module_file"
                    set -o allexport
                    source "$module_file"
                    set +o allexport
                else
                    debug_echo "DEBUG" "Sourcing file: $module_file"
                    source "$module_file"
                fi
            else
                debug_echo "WARN" "Skipping unreadable or non-existent file: $module_file"
            fi
        done

        # Disable nullglob after use to avoid unexpected behavior elsewhere
        unsetopt nullglob
    else
        debug_echo "ERROR" "Directory not found: $module_dir"
    fi
}

log_to_file() {
    local log_file="${SKOGAI_LOG_FILE:-$HOME/skogai/logs/zsh.d.log}" # Default to fallback log file
    local log_message="$2" # Message to write to the log file

    # Ensure the directory for the log file exists
    local log_dir
    log_dir=$(dirname "$log_file")
    if [[ ! -d "$log_dir" ]]; then
        mkdir -p "$log_dir" || {
            echo "Error: Unable to create log directory: $log_dir" >&2
            return 1
        }
    fi

    # Create the log file if it doesn't exist
    if [[ ! -f "$log_file" ]]; then
        touch "$log_file" || {
            debug_echo "Error: Unable to create log file: $log_file" >&2
            return 1
        }
    fi

    # Append the message to the log file with a timestamp
    echo "$(date '+%Y-%m-%d %H:%M:%S') $log_message" >> "$log_file"
}

debug_echo() {
    local message_level="$1"
    local message="$2"

    # Default debug level to INFO if not set
    local current_level="${SKOGAI_DEBUG_LEVEL:-INFO}"

    # Define levels in order of severity
    local levels=("LOG" "ERROR" "WARN" "INFO" "DEBUG")

    # Get numeric indices for the levels
    local message_index=$(echo ${levels[@]} | grep -o -b "$message_level" | cut -d: -f1 | tr -d ' ')
    local current_index=$(echo ${levels[@]} | grep -o -b "$current_level" | cut -d: -f1 | tr -d ' ')

    # Always log to file
    log_to_file "$SKOGAI_LOG_FILE" "[$message_level] $message"

    # Print to console if the level is above LOG
    if (( current_index > 0 && message_index <= current_index )); then
        echo "$message"
    fi
}
