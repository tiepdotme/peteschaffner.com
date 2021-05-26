.PHONY: build
build:
	@swift run PeteSchaffner

.PHONY: serve
serve:
	@swift run PeteSchaffner --serve

.PHONY: readlater
readlater:
	@sh bin/readlater.sh

.PHONY: publish
publish:
	@ssh pete@155.133.130.170 "cd ~/www/peteschaffner.com && \
		rm -rf .publish/Caches && \
		git pull --rebase && \
		/opt/swift-5.4-RELEASE-ubuntu18.04/usr/bin/swift run PeteSchaffner"
