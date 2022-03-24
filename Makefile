POST_DATE = $(shell date "+%Y-%m-%d-%H%M")

.PHONY: build
build:
	@bin/hugo --cleanDestinationDir && find public -name '*.html' -type f -print -exec bin/tidy -miq '{}' \;

.PHONY: serve
serve:
	@bin/hugo server --navigateToChanged --buildDrafts

.PHONY: post
post:
	bin/hugo new blog/$(POST_DATE)

.PHONY: publish
publish:
	@ssh ubuntu@46.226.107.32 "cd /var/www/peteschaffner.com && \
		git pull --rebase && \
		make build"
