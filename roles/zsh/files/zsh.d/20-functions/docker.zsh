dockerclean() {
    local containers=$(docker ps -a -q)
    [[ -n "$containers" ]] && docker rm $containers

    local images=$(docker images -q)
    [[ -n "$images" ]] && docker rmi $images

    local volumes=$(docker volume ls -f dangling=true -q)
    [[ -n "$volumes" ]] && docker volume rm $volumes
}
