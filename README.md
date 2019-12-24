# Twitternator

Twitter automation with [send-tweet][send-tweet].

## The Idea

I want a simple solution to automate Tweets. What is my use case? I want to write some Tweets ahead of time and this tool posts them at a specified date and time.

## Architecture

- Use a full VM because Docker does not provide `initd` and so `crond` and `atd` would not work and all other solutions would be massive pain in the ass.
- Installation of all necessary things via `make`:
  - Pull in this repo on the target machine and execute `make`.
  - An alternative way would be Ansible.
  - There is a Vagrant file for local testing.
- The data with the tweets to send in the future are in a separate data repository.
- Basically everything is in a shell script based on `crond` and `atd`:
  - `crond` periodically invokes the main script which pulls the data repository and submits `atd` jobs from this data.
  - `atd` calls the main script to send the tweet.

Format of the tweet data file (`data.txt`):

```text
HH:MM DD.MM.YYYY|TWEET\n
HH:MM DD.MM.YYYY|TWEET\n
HH:MM DD.MM.YYYY|TWEET\n
...
```

Example:

```text
12:30 20.12.2019|Here comes the tweet: https://www.google.de
12:35 20.12.2019|Another Tweet!
```

## Prerequisites

- You need a Debian based Linux box with `git` and `make` installed. Tested on Debian Buster. In this repo is a Vagrant file for testing arround.
- You need Tokens from Twitter.

## Installation

**IMPORTANT**: I'm lazy so everything runs as root. Maybe I do some rework so that it runs as a non-privileged user.

1. Checkout this repo on your target machine.
2. Copy the `config.sample` to `config` and fill out the gaps. (You need a separate repo with a file `data.txt` for your planned tweets.)
3. Run `make` to install Twitternator.
4. Run `twitternator.sh init` as final step.

[send-tweet]: https://github.com/zacanger/send-tweet
