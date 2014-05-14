#
# This is a template for a module makefile.
# The goal of this file is to show capabilities of the ANREM system,
# and provide example use cases for which ANREM has been designed.
#

# see main/module.mk for a description of these first lines
CURRENT := $(call anrem-current-path)

# for example the required files are defined as non-local
CALC_deps = $(addprefix $(CURRENT)/,calc.c)
CALC_obj = $(CALC_deps:%.c=%.o)

$(call anrem-target, $(CALC_obj)): $(CALC_deps)
	$(CC) -c -o $@ $^

$(call anrem-clean):
	rm -f $(path)/*.o
