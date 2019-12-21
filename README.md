# Twitternator

Twitter automation with [send-tweet][send-tweet].

## The Idea

I want a simple solution to automate Tweets. What is my use case? I want to write some Tweets ahead of time and this tool posts them at a specified date and time.

## Architecture

- A minimal Docker container with [send-tweet][send-tweet].
- The scheduled Tweets are stored in an Git repository.
- The container regularly pulls the repository and schedules the tweets.

Format of the tweet data file:

```text
HH:MM DD.MM.YYYY TWEET\n
HH:MM DD.MM.YYYY TWEET\n
HH:MM DD.MM.YYYY TWEET\n
...
```

Example:

```text
12:30 20.12.2019 Here comes the tweet: https://www.google.de
12:35 20.12.2019 Another Tweet!
```

A script pulls this in and pumps it into `/usr/bin/at`:

```bash
echo "send-tweet 'TWEET'" | at HH:MM DD.MM.YYYY
```

Example:

```bash
echo "send-tweet 'Here comes the tweet: https://www.google.de'" | at 12:30 20.12.2019
```

## Build and Run

Run `make help` to see the available build targets.

Delete all at jobs:

```bash
at -l | awk '{printf "%s ", $1}' | xargs atrm
```

[send-tweet]: https://npm.taobao.org/package/send-tweet
