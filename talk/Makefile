SHELL := bash

VROOM := \
    vroom \
    clean \

default:
ifdef s
	vroom vroom --skip=$s
else
	vroom vroom
endif

$(VROOM):
	vroom $@
