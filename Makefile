.PHONY: build
build:
	@swift run PeteSchaffner

.PHONY: serve
serve:
	@swift run PeteSchaffner --serve

.PHONY: publish
publish:
	@ssh ubuntu@46.226.107.32 "cd /var/www/peteschaffner.com && \
		rm -rf .publish/Caches && \
		git pull --rebase && \
		/opt/swift-5.4.1-RELEASE-ubuntu20.04/usr/bin/swift run PeteSchaffner"
