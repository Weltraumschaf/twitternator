#!/bin/sh

set -eu

# shellcheck source=config.sample disable=SC1091
. "${HOME}/.config/twitternator"

USAGE="$(basename "${0}") init|cron|tweet"
CMD="${1:-}"
DATA_DIR="${HOME}/twitternator-data"
DATA_FILE="${DATA_DIR}/data.txt"

log() {
    echo "T10R: ${1}"
}

twitternator_init() {
    echo " _____          _ _   _                        _             "
    echo "|_   _|_      _(_) |_| |_ ___ _ __ _ __   __ _| |_ ___  _ __ "
    echo "  | | \ \ /\ / / | __| __/ _ \ '__| '_ \ / _\` | __/ _ \\| '__|"
    echo "  | |  \ V  V /| | |_| ||  __/ |  | | | | (_| | || (_) | |   "
    echo "  |_|   \_/\_/ |_|\__|\__\___|_|  |_| |_|\__,_|\__\___/|_|   "
    echo "                                                             "

    log "Init ..."
    git clone "${GIT_DATA_REPO_URL}" "${DATA_DIR}"
}

twitternator_cron() {
    log "Updating jobs from ${DATA_DIR} ..."

    result=$(cd "${DATA_DIR}" && git pull)

    if [ "${result}" = "Already up to date." ]; then
        log "Nothing to do ($result)."
        exit 0
    fi


    while IFS= read -r line; do
        time=$(echo "$line" | cut -d"|" -f1)
        tweet=$(echo "$line" | cut -d"|" -f2)
        job="${HOME}/bin/twitternator.sh tweet '$tweet'"

        log "Submit job '${job}' at ${time}"
        echo "${job}" | at -m "${time}" || true
    done < "$DATA_FILE"
}

twitternator_tweet() {
    tweet="${2:-}"

    if [ "${tweet}" = "" ]; then
        log "Empty tweet, given ignoring!"
        exit
    fi

    log "send-tweet: ${tweet}"
    /usr/local/bin/send-tweet "${tweet}"
}

log "--<<== TWITTERNATOR ==>>--"
log "Running as $(whoami) with shell ${SHELL:-n/a}."

case "${CMD}" in
init)
    twitternator_init
    ;;
cron)
    twitternator_cron
    ;;
tweet)
    twitternator_tweet "$@"
    ;;
*)
    log "FATAL: No comamnd given!"
    log "${USAGE}"
    exit 1
    ;;
esac

