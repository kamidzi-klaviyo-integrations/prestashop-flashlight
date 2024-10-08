depends := gnu-getopt
depend_targets := install-deps

.PHONY: install-deps up build-clean help


help:	## Shows this help
	@@echo Available targets
	@@echo -----------------
	@@echo
	@@sed -E -ne 's/^([^#[:space:]\\.][^ :]+): ?[^#]+(## )?(.*)$$/\1 "\3"/p' $(MAKEFILE_LIST) | \
		xargs printf " %-32s %s\n"

install-deps: ## Install dependencies
	brew install ${depends}

build-clean: ${depend_targets} ## Builds clean environment
	./build-env.sh -d --force-recreate

up: ${depend_targets} ## Bring up environment
	./build-env.sh -d

