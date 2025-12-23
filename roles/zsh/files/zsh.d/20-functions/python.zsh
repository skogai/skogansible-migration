use_venv() {
    uv venv
    source .venv/bin/activate
}

use_standard-python() {
    source_up_if_exists
    dotenv_if_exists
    source_env_if_exists .envrc.local
    use venv
    uv sync
}

layout_uv() {
    if [[ -d "$UV_PROJECT_ENVIRONMENT" ]]; then
        log_status "Existing project virtual environment \'$UV_PROJECT_ENVIRONMENT\'"
    else
        log_status "No project virtual environment exists."

        if [[ ! -f "pyproject.toml" ]]; then
            log_status "Initializing a new Python project via \`uv init\`."
            uv init --no-readme
        else
            log_status "Python project already initialized. Skipping \`uv init\`."
        fi
        [[ -f "hello.py" ]] && rm hello.py

        if [[ ! -z "$UV_PROJECT_ENVIRONMENT" ]]; then
            log_status "Project virtual environment path set to : $UV_PROJECT_ENVIRONMENT"
            uv venv "$UV_PROJECT_ENVIRONMENT"
        else
            uv venv
            UV_PROJECT_ENVIRONMENT="$(pwd)/.venv"
        fi
    fi

    PATH_add "$UV_PROJECT_ENVIRONMENT/bin"
    export UV_ACTIVE=1
    export UV_PROJECT_ENVIRONMENT
}
