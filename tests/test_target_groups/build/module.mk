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
$(call anrem-local-set, build_target, $(addprefix $(CURRENT)/,hello))

$(call anrem-build, @build_target): $(CURRENT)/hello.o $(call anrem-target-group-depend, build_group)
	$(CC) -o $@ $< $(call anrem-target-group-members, build_group)

$(call anrem-target, $(CURRENT)/hello.o): $(CURRENT)/hello.c
	$(CC) -c -o $@ $(addprefix -I ,$(call anrem-target-group-modules, build_group)) $<

$(call anrem-clean):
	rm -f $(call anrem-local-get, build_target)
	rm -f $(path)/*.o
