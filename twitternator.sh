#!/bin/sh

set -eu

# shellcheck source=config.sample disable=SC1091
. "${HOME}/.config/twitternator"

USAGE="$(basename "${0}") clear|cron|init|help|tweet"
HELP=$(cat <<- EOT
clear                   Clears the job queue wit hall tweets to send.
cron                    Periodic command called by a cron job.
init                    Initializes Twitternator, must be called once after install.
help                    Prints this help.
tweet 'Your tweet!'     Sends a tweet.
EOT
)

DATA_DIR="${HOME}/twitternator-data"
DATA_FILE="${DATA_DIR}/data.txt"

log() {
    echo "$(date -u +'%Y-%m-%dT%H:%M:%SZ') T10R: ${1}"
}

twitternator_clear() {
    log "Clearing all jobs from atd ..."
    at -l | awk '{printf "%s ", $1}' | xargs atrm
}

twitternator_cron() {
    if [ ! -d "${DATA_DIR}" ]; then
        log "There is no data direcotry at ${DATA_DIR}. Do nothing!"
        exit 0
    fi

    log "Updating jobs from ${DATA_DIR} ..."

    result=$(cd "${DATA_DIR}" && git pull)

    if [ "${result}" = "Already up to date." ]; then
        log "Nothing to do ($result)."
        exit 0
    fi

    twitternator_clear

    while IFS= read -r line; do
        time=$(echo "$line" | cut -d"|" -f1)
        tweet=$(echo "$line" | cut -d"|" -f2)
        job="${HOME}/bin/twitternator.sh tweet '$tweet'"

        log "Submit job '${job}' at ${time}"
        echo "${job}" | at -m "${time}" || true
    done < "$DATA_FILE"
}

twitternator_help() {
    echo "${USAGE}"
    echo
    echo "${HELP}"
    echo
}

twitternator_init() {
    log "Init ${DATA_DIR} from ${GIT_DATA_REPO_URL} ..."
    git clone "${GIT_DATA_REPO_URL}" "${DATA_DIR}"
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
CMD="${1:-}"

case "${CMD}" in
cron)
    twitternator_cron
    ;;
clear)
    twitternator_clear
    ;;
init)
    twitternator_init
    ;;
help)
    twitternator_help
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

