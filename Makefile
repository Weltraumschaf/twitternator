.PHONY: all install help
all: install

install:
	@echo "Installing ..."
	@apt-get update
	@apt-get install -y locales git cron at nodejs npm
	@localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
	@export LANG="en_US.utf8"
	@npm i -g send-tweet

help:
	@echo "Execute one of these targets:"
	@echo " - install: Install all stuff on target system."
