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
deps_$(CURRENT) = $(addprefix $(CURRENT)/,hello.c)

# an alternate way to do that is to use tha ANREM local variables helpers:
$(call anrem-local-set, build_targets, $(addprefix $(CURRENT)/,hello))
# the set syntax can also be used like that:
# $(call anrem-local, build_targets) := <my_variable_value>
# the getter can also be used in two ways
# $(call anrem-local-get, build_targets) or
# $($(call anrem-local, build_targets))
# however the get and set functions are recommended since the
# expression is clearer

$(call anrem-build, $(call anrem-local-get, build_targets)): $(deps_$(CURRENT))
	$(CC) -o $@ $^

$(call anrem-clean):
	rm -f $(call anrem-local-get, build_targets)
