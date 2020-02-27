POST_DATE := $(shell date +%Y-%m-%d)
POST_META_TIME := $(shell date +%H:%M)
POST_TIME_STAMP := $(shell date +%H%M)
POST_FILE := Content/words/$(POST_DATE)-$(POST_TIME_STAMP).md
SWIFT_RUN_COMMAND := $(swift run PeteSchaffner --build-path=.tmp)

/usr/local/bin/entr:
	@echo "entr (https://github.com/eradman/entr) is required. Installing..."
	@git clone https://github.com/eradman/entr.git
	@cd entr
	@./configure
	@make install
	@cd ..
	@rm -rf entr

/usr/local/bin/site:
	@echo "site.js (https://sitejs.org) is required. Installing..."
	@curl -s https://sitejs.org/install | bash

.PHONY: dev
dev: /usr/local/bin/site /usr/local/bin/entr
	@site Output &
	@while true; do find . ! -path "*/\.*" ! -path "./Output/*" | entr -d swift run --build-path=.tmp PeteSchaffner; done &>/dev/null

.PHONY: publish
publish: /usr/local/bin/site
	@swift run --build-path=.tmp PeteSchaffner --removeDrafts
	@site Output --sync-to=pete@139.162.204.237:www --exit-on-sync

.PHONY: blog
blog:
	@touch $(POST_FILE)
	@echo "---\ndate: $(POST_DATE) $(POST_META_TIME)\n---\n" >> $(POST_FILE)
