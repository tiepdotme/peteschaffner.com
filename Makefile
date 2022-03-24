POST_DATE = $(shell date "+%Y-%m-%d-%H%M")
SYSTEM_NAME = "$(shell uname)"
HUGO_BINARY = $(shell if [ $(SYSTEM_NAME) = "Darwin" ]; then echo bin/mac/hugo; else echo bin/linux/hugo; fi)
TIDY_BINARY = $(shell if [ $(SYSTEM_NAME) = "Darwin" ]; then echo bin/mac/tidy; else echo bin/linux/tidy; fi)

.PHONY: build
build:
	@$(HUGO_BINARY) --cleanDestinationDir && find public -name '*.html' -type f -print -exec $(TIDY_BINARY) -miq '{}' \;

.PHONY: serve
serve:
	@$(HUGO_BINARY) server --navigateToChanged --buildDrafts

.PHONY: post
post:
	@$(HUGO_BINARY) new blog/$(POST_DATE)

.PHONY: publish
publish:
	@ssh ubuntu@46.226.107.32 "cd /var/www/peteschaffner.com && \
		git pull --rebase && \
		make build"
