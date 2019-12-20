BUILD_VERSION	:= "1.0.0"
BUILD_DATE		:= "$(shell date -u +'%Y-%m-%dT%H:%M:%SZ')"
VCS_REF			:= "$(shell git rev-parse --short HEAD)"
NO_CACHE		?= "false"

all: build

build:
	@echo "Build Docker image..."
	@echo "BUILD_VERSION: ${BUILD_VERSION}"
	@echo "BUILD_DATE:    ${BUILD_DATE}"
	@echo "VCS_REF:       ${VCS_REF}"
	@echo "NO_CACHE:      ${NO_CACHE}"
	@docker image build  \
		--no-cache="${NO_CACHE}" \
		--build-arg BUILD_DATE="${BUILD_DATE}" \
		--build-arg BUILD_VERSION="${BUILD_VERSION}" \
		--build-arg VCS_REF="${VCS_REF}" \
		-t "weltraumschaf/twitternator:${BUILD_VERSION}" .

run:
	@echo "Run Docker container..."
	@docker container run --rm -d \
		-e SEND_TWEET_CONSUMER_KEY="${TWITTER_CONSUMER_KEY}" \
		-e SEND_TWEET_CONSUMER_SECRET="${TWITTER_CONSUMER_SECRET_KEY}" \
		-e SEND_TWEET_ACCESS_TOKEN_KEY="${TWITTER_ACCESS_TOKEN_KEY}" \
		-e SEND_TWEET_ACCESS_TOKEN_SECRET="${TWITTER_ACCESS_TOKEN_SECRET}" \
		--name twitternator \
		"weltraumschaf/twitternator:${BUILD_VERSION}"

help:
	@echo "Execute one of these targets:"
	@echo " - build:       Build the Docker image."
	@echo " - run:         Run the Docker container."
