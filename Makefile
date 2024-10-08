depends := gnu-getopt

.PHONY: install-deps up clean help

help:
	@LC_ALL=C $(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/(^|\n)# Files(\n|$$)/,/(^|\n)# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | grep -E -v -e '^[^[:alnum:]]' -e '^$@$$'

install-deps:
	brew install ${depends}

up:
	./build-env.sh -d

clean:
	./build-env.sh -d --force-recreate
	
