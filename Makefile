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
	@python3 server.py

.PHONY: publish
publish:
	@rm -rf .publish/Caches
	@swift run PeteSchaffner
	@mkdir tmp
	@cp -r Output tmp/htdocs
	@cd tmp && \
		git init && \
		git remote add gandi git+ssh://3643620@git.sd3.gpaas.net/peteschaffner.com.git && \
		git add . && \
		git commit -m 'build' && \
		git push gandi master --force && \
		ssh 3643620@git.sd3.gpaas.net deploy peteschaffner.com.git && \
		ssh 3643620@git.sd3.gpaas.net clean peteschaffner.com.git && \
		cd .. && \
		rm -rf tmp

.PHONY: blog
blog:
	@touch $(POST_FILE)
	@echo "---\ndate: $(POST_DATE) $(POST_META_TIME)\n---\n" >> $(POST_FILE)
