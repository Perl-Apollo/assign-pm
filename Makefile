SHELL := bash

ZILD := dist distdir distshell disttest release

export RELEASE_BRANCH := main

harness ?= yath test
test ?= test/
opts ?= -lv


default:

.PHONY: test
test:
	$(harness) $(opts) $(test)

$(ZILD):
	zild $@
