#!/bin/sh

set -ue

USAGE="send-tweet.sh \"The tweet\""
TWEET=${1:-}

if [ "${TWEET}" = "" ]; then
    echo "No tweet given!"
    echo "${USAGE}"
    exit 1
fi

docker run --rm -it \
    -e SEND_TWEET_CONSUMER_KEY="${TWITTER_CONSUMER_KEY}" \
    -e SEND_TWEET_CONSUMER_SECRET="${TWITTER_CONSUMER_SECRET_KEY}" \
    -e SEND_TWEET_ACCESS_TOKEN_KEY="${TWITTER_ACCESS_TOKEN_KEY}" \
    -e SEND_TWEET_ACCESS_TOKEN_SECRET="${TWITTER_ACCESS_TOKEN_SECRET}" \
    weltraumschaf/twitternator:1.0.0 \
    "${TWEET}"

