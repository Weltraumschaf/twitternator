FROM debian:buster-slim
LABEL maintainer="ich@weltraumschaf.de"

ARG BUILD_DATE
ARG VCS_REF
ARG BUILD_VERSION

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="weltraumschaf/twitternator"
LABEL org.label-schema.description="automate your Twitter."
LABEL org.label-schema.url="http://www.weltraumschaf.de/"
LABEL org.label-schema.vcs-url="https://github.com/Weltraumschaf/twitternator"
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.vendor="Weltraumschaf"
LABEL org.label-schema.version=$BUILD_VERSION
LABEL org.label-schema.docker.cmd="docker container run --rm -d -e SEND_TWEET_CONSUMER_KEY=... -e SEND_TWEET_CONSUMER_SECRET=... -e SEND_TWEET_ACCESS_TOKEN_KEY=... -e SEND_TWEET_ACCESS_TOKEN_SECRET=... -e GIT_DATA_REPO_URL=... weltraumschaf/twitternator:${BUILD_VERSION}"

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y \
    locales git cron at nodejs npm

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN npm i -g send-tweet

ADD crontab /etc/cron.d/twitternator
RUN chmod 644 /etc/cron.d/twitternator
RUN touch /var/log/cron.log

WORKDIR /root
COPY twitternator.sh .

CMD /root/twitternator.sh init && cron -n && tail -f /var/log/cron.log
