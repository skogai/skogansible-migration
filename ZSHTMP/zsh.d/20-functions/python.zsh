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
    source_up_if_exists
    dotenv_if_exists
    source_env_if_exists .envrc.local
    use venv
    uv sync
    if [[ -d "$UV_ACTIVE" ]]; then
        echo "Existing project virtual environment \'$UV_PROJECT_ENVIRONMENT\'"
    else
        echo "No project virtual environment exists."


        if [[ ! -f "pyproject.toml" ]]; then
            echo "Initializing a new Python project via \`uv init\`."
            uv init --no-readme
        else
            echo "Python project already initialized. Skipping \`uv init\`."
        fi
        [[ -f "hello.py" ]] && rm hello.py

        if [[ ! -z "$UV_PROJECT_ENVIRONMENT" ]]; then
            echo "Project virtual environment path set to : $UV_PROJECT_ENVIRONMENT"
            uv venv "$UV_PROJECT_ENVIRONMENT"
        else
            uv venv --seed
            UV_PROJECT_ENVIRONMENT="$(pwd)/.venv"
        fi
    fi

    PATH_add "$UV_PROJECT_ENVIRONMENT/bin"
    export UV_ACTIVE=1
    export UV_PROJECT_ENVIRONMENT
    export UV_VENV_CLEAR=1
    eval "$(skogcli config export-env --namespace skogai,uv)"
}
