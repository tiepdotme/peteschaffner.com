POST_DATE := $(shell date +%Y-%m-%d)
POST_META_TIME := $(shell date +%H:%M)
POST_TIME_STAMP := $(shell date +%H%M)
POST_FILE := Content/words/$(POST_DATE)-$(POST_TIME_STAMP).md

.PHONY: build
build:
	@swift run PeteSchaffner

.PHONY: serve
serve:
	@swift run PeteSchaffner --serve

.PHONY: readlater
readlater:
	@sh bin/readlater.sh

.PHONY: blog
blog:
	@touch $(POST_FILE)
	@echo "---\ndate: $(POST_DATE) $(POST_META_TIME)\n---\n" >> $(POST_FILE)

.PHONY: compile-drafts
compile-drafts:
	swift run PeteSchaffner --compile-drafts

.PHONY: publish
publish:
	@ssh pete@155.133.130.170 "cd ~/www/peteschaffner.com && \
		rm -rf .publish/Caches && \
		git pull --rebase && \
		/opt/swift-5.4-RELEASE-ubuntu18.04/usr/bin/swift run PeteSchaffner"
