.PHONY: all install help
all: install

install:
	@echo "Installing ..."
	apt-get update
	apt-get install -y locales cron at nodejs npm
	localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
	export LANG="en_US.utf8"
	timedatectl set-timezone Europe/Berlin
	npm i -g send-tweet
	cp crontab /etc/cron.d/twitternator
	chmod 644 /etc/cron.d/twitternator
	touch /var/log/twitternator.log
	mkdir -p ${HOME}/bin
	cp twitternator.sh ${HOME}/bin/twitternator.sh
	chmod 755 ${HOME}/bin/twitternator.sh
	mkdir -p ${HOME}/.config
	cp config ${HOME}/.config/twitternator
	chmod 644 ${HOME}/.config/twitternator
	cp bash_exports ${HOME}/.bash_exports
	grep -qxF 'source "${HOME}/.bash_exports"' ${HOME}/.bashrc || echo 'source "${HOME}/.bash_exports"' >> ${HOME}/.bashrc
	@echo "FINISHED: Make you root and run: twitternator.sh init"

help:
	@echo "Execute one of these targets:"
	@echo " - install: Install all stuff on target system."
