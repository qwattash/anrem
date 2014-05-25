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


#%.o: %.c
#	@echo $(deps)
#	$(call anrem-def-call-auto-hook)
#	$(eval $(call anrem-hook-makedepend, $@, $*.d, $<))
#	gcc -c -o $@ $<

$(call anrem-clean):
	rm -f $(tgts)
	rm -f $(obj)
	rm -f $(path)/.deps/*




#$(call anrem-auto-target, %.o, %.c, $(FALSE),$(obj),$(NULL))
#	@echo $(deps)
#	$(CC) -c -o $@ $<
#$(info $(eval $(call anrem-def-call-auto-hook)))
#$(info $(call anrem-def-call-auto-hook))

#$(call anrem-def-auto-header,%.o,%.c)
#	$(call anrem-def-call-auto-hook-dd)
#	gcc -c -o $@ $<

#$(eval $(call anrem-def-auto-target-dd))

#--------------------- solution 2
# this is a working one!

#define rule =
#gcc -c -o $$@ $$<
#@echo "pippo"
#endef

#$(call anrem-auto-target-2, %.o, %.c, rule)

#-------------------- solution 3

$(call anrem-auto-target-3, %.o, %.c,$(FALSE),$(NULL),$(NULL))
	gcc -c -o $@ $<
	@echo "pippo"
