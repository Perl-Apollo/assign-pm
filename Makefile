SHELL := bash

ZILD := clean dist distdir distshell disttest release update

export RELEASE_BRANCH := main

ifneq (,$(shell command -v yath))
  harness ?= yath test
else
  harness ?= prove
endif

test ?= test/
opts ?= -lv


default:

.PHONY: test
test:
	$(harness) $(opts) $(test)

$(ZILD):
	zild $@
