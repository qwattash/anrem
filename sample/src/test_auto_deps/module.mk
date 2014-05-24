#
# This is a template for a module makefile.
# The goal of this file is to show capabilities of the ANREM system,
# and provide example use cases for which ANREM has been designed.
#

# get current module path, this can be used later for a number of
# purposes
CURRENT := $(call anrem-current-path)


tgts := $(CURRENT)/hello

obj := $(CURRENT)/hello.o

$(call anrem-build, $(tgts)): $(obj)
	$(CC) -o $@ $^

$(info $(call anrem-auto-target, %.o, %.c, $(TRUE),$(obj),$(NULL)))
#$(call anrem-auto-target)

$(call anrem-clean):
	rm -f $(tgts)
	rm -f $(obj)
	rm -f $(path)/.deps/*
