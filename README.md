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

Format of the tweet data file:

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

## Build and Run

Run `make help` to see the available build targets.

[send-tweet]: https://npm.taobao.org/package/send-tweet
