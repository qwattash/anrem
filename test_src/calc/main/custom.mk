#
# This is a template for a module makefile.
# The goal of this file is to show capabilities of the ANREM system,
# and provide example use cases for which ANREM has been designed.
#

# see main/module.mk for a description of these first lines
CURRENT := $(call anrem-current-path)

# for example the required files are defined as non-local
CALC_MAIN_deps := $(addprefix $(CURRENT)/,calcmain.c)
CALC_MAIN_obj := $(CALC_MAIN_deps:%.c=%.o)

$(call anrem-target, $(CALC_MAIN_obj)): $(CALC_MAIN_deps)
	$(CC) -c -o $@ $^

$(call anrem-target, calc_main_clean):
	rm -f $(path)/*.o

$(call anrem-clean, calc_main_clean)
