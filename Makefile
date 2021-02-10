POST_DATE := $(shell date +%Y-%m-%d)
POST_META_TIME := $(shell date +%H:%M)
POST_TIME_STAMP := $(shell date +%H%M)
POST_FILE := Content/words/$(POST_DATE)-$(POST_TIME_STAMP).md

.PHONY: build
build:
	@swift run PeteSchaffner

.PHONY: serve
serve:
	@pip3 install websocket-server
	@pip3 install watchgod
	@python3 bin/server.py

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
	@rm -rf .publish/Caches
	@swift run PeteSchaffner
	@[ -d "/home/pete" ] && rsync -avz --delete Output/ /home/pete/www/peteschaffner.com || rsync -avz --delete Output/ pete@155.133.130.170:~/www/peteschaffner.com/
