# Twitternator

Twitter automation with [send-tweet][send-tweet].

## The Idea

I want a simple solution to automate Tweets. What is my use case? I want to write some Tweets ahead of time and this tool posts them at a specified date and time.

## Architecture

- A minimal Docker container with [send-tweet][send-tweet].
- The scheduled Tweets are stored in an Git repository.
- The container regularly pulls the repository and schedules the tweets.

## Build and Run

```bash
 docker image build  -t weltraumschaf/twitternator:1.0.0 .
 ```

 ```bash
 bin/send-tweet.sh 'This is a tweet!'
 ```

 [send-tweet]: https://npm.taobao.org/package/send-tweet
