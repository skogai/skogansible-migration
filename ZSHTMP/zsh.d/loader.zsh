local zsh_d="${0:h}"

for dir in "$zsh_d"/[0-9]*(/N); do
    for file in "$dir"/*.(zsh|sh|conf)(N); do
        source "$file"
    done
    for file in "$dir"/*.env(N); do
        set -o allexport
        source "$file"
        set +o allexport
    done
done
