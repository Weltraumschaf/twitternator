#!/usr/bin/env bash

set -eu

USAGE="$(basename "${0}") init|cron"
CMD="${1:-}"
DATA_DIR="${HOME}/twitternator-data"

function log() {
    echo "TWITTERNATOR: ${1}"
}

function twitternator_init() {
    echo " _____          _ _   _                        _             "
    echo "|_   _|_      _(_) |_| |_ ___ _ __ _ __   __ _| |_ ___  _ __ "
    echo "  | | \ \ /\ / / | __| __/ _ \ '__| '_ \ / _\` | __/ _ \\| '__|"
    echo "  | |  \ V  V /| | |_| ||  __/ |  | | | | (_| | || (_) | |   "
    echo "  |_|   \_/\_/ |_|\__|\__\___|_|  |_| |_|\__,_|\__\___/|_|   "
    echo "                                                             "

    log "Init ..."
    git clone "${GIT_DATA_REPO_URL}" "${DATA_DIR}"
}

function twitternator_cron() {
    log "Cron ..."
    (cd "${DATA_DIR}" && git pull)
}

function main() {
    case "${CMD}" in
    init)
        twitternator_init
        ;;
    cron)
        twitternator_cron
        ;;
    *)
        echo "FATAL: No comamnd given!"
        echo "${USAGE}"
        exit 1
        ;;
    esac
}

main
