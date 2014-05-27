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
$(call anrem-local-set, deps, $(addprefix $(CURRENT)/,mod1.c))
$(call anrem-local-set, obj, $(patsubst %.c,%.o,$(call anrem-local-get, deps)))

# register target to group build_group
$(call anrem-target-group-add, build_group, $(call anrem-local-get, obj))

$(call anrem-target, $(call anrem-local-get, obj)): $(call anrem-local-get, deps)
	$(CC) -c -o $@ $<

$(call anrem-clean):
	rm -f $(path)/*.o
