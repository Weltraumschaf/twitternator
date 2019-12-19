FROM weltraumschaf/debian-nodejs-v8:1.0.0

RUN npm i -g send-tweet

ENTRYPOINT [ "/usr/local/bin/send-tweet" ]
