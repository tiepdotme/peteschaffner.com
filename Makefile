POST_DATE := $(shell date +%Y-%m-%d)
POST_META_TIME := $(shell date +%H:%M)
POST_TIME_STAMP := $(shell date +%H%M)
POST_FILE := Content/words/$(POST_DATE)-$(POST_TIME_STAMP).md

.PHONY: sitejs
sitejs:
	@if [ -z "$(shell which site)" ]; then echo "site.js is required: curl -s https://sitejs.org/install | bash"; exit 1; fi

.PHONY: dev
dev: sitejs
	@swift run
	@site Output

.PHONY: publish
deploy: sitejs
	@swift run
	@site Output --sync-to=pete@139.162.204.237:www --exit-on-sync

.PHONY: blog
blog:
	@touch $(POST_FILE)
	@echo "---\ndate: $(POST_DATE) $(POST_META_TIME)\n---\n" >> $(POST_FILE)
