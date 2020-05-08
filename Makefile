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
		--event Updated . | xargs -0 -n 1 /bin/bash -c "swift run PeteSchaffner && osascript -e 'tell application \"Safari\"' -e 'tell window 1' -e 'do JavaScript \"window.location.reload(true)\" in current tab' -e 'end tell' -e 'end tell'" &
	@cd Output && python -m SimpleHTTPServer 8000

.PHONY: publish
publish:
	@swift run PeteSchaffner --removeDrafts
	@echo "put -r Output/*" | sftp 3643620@sftp.sd3.gpaas.net:vhosts/lauraschaffner.com/htdocs

.PHONY: blog
blog:
	@touch $(POST_FILE)
	@echo "---\ndate: $(POST_DATE) $(POST_META_TIME)\n---\n" >> $(POST_FILE)
