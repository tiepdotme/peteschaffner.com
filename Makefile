Output:
	@swift run

.PHONY: sitejs
sitejs:
	@if [ -z "$(shell which site)" ]; then echo "site.js is required: curl -s https://sitejs.org/install | bash"; exit 1; fi

.PHONY: dev
dev: Output sitejs
	@site Output

.PHONY: deploy
deploy: Output sitejs
	@site Output --sync-to=pete@139.162.204.237:www --exit-on-sync
