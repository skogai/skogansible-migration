# Load secrets deployed by ansible to ~/.ssh/loadme.env
[[ -f "$HOME/.ssh/loadme.env" ]] && set -o allexport && source "$HOME/.ssh/loadme.env" && set +o allexport
