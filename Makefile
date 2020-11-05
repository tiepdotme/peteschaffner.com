POST_DATE := $(shell date +%Y-%m-%d)
POST_META_TIME := $(shell date +%H:%M)
POST_TIME_STAMP := $(shell date +%H%M)
POST_FILE := Content/words/$(POST_DATE)-$(POST_TIME_STAMP).md

/usr/local/bin/fswatch:
	@if [ -z "$(shell which brew)" ]; then echo "homebrew is required to install fswatch: https://brew.sh"; exit 1; fi
	@echo "fswatch is required. Installing..."
	@brew install fswatch

.PHONY: dev
dev: /usr/local/bin/fswatch
	@swift run PeteSchaffner
	@fswatch -m kqueue_monitor -0ro \
		-e "/\." \
		-e "Output" \
		-e "~" \
		-e "Resources/resume-references" \
		--event Updated . | xargs -0 -n 1 /bin/bash -c "swift run PeteSchaffner && osascript -e 'tell application \"Safari\"' -e 'tell window 1' -e 'if URL of current tab contains \"localhost:8000\" then do JavaScript \"window.location.reload(true)\" in current tab' -e 'end tell' -e 'end tell'" &
	@cd Output && python -m SimpleHTTPServer 8000

.PHONY: publish
publish:
	@rm -rf .publish/Caches
	@swift run PeteSchaffner --removeDrafts
	@mkdir tmp
	@cp -r Output tmp/htdocs
	@ln -s /srv/data/home/FreshRSS/p tmp/htdocs
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
