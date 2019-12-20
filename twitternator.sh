#!/bin/sh

set -eu

USAGE="$(basename "${0}") init|cron"
CMD="${1:-}"
DATA_DIR="${HOME}/twitternator-data"

case "${CMD}" in
init)
    git clone "${GIT_DATA_REPO_URL}" "${DATA_DIR}"
    ;;
cron)
    (cd "${DATA_DIR}" && git pull)
    ;;
*)
    echo "FATAL: No comamnd given!"
    echo "${USAGE}"
    exit 1
    ;;
esac