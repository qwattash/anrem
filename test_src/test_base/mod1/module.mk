#
# This is a template for a module makefile.
# The goal of this file is to show capabilities of the ANREM system,
# and provide example use cases for which ANREM has been designed.
#

# get current module path, this can be used later for a number of
# purposes
CURRENT := $(call anrem-current-path)

# these are local variables defined with the help of the auto-inclusion system CURRENT path
# local variables are notationally expensive as you can see below, so use them only if it
# is really necessary
BUILD_TARGETS_$(CURRENT) := $(addprefix $(CURRENT)/,hello)

deps_$(CURRENT) = $(addprefix $(CURRENT)/,hello.c)

$(call anrem-target, $(BUILD_TARGETS_$(CURRENT))): $(deps_$(CURRENT))
	$(CC) -o $@ $^

$(call anrem-target, clean_$(CURRENT)):
	rm -f $(BUILD_TARGETS_$(path))

# those add to the global anrem build and clean targets the targets defined above
# in future they may be merged into anrem-target directly
$(call anrem-build, $(BUILD_TARGETS_$(CURRENT)))
$(call anrem-clean, clean_$(CURRENT))
