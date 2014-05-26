#
# This is a template for a module makefile.
# The goal of this file is to show capabilities of the ANREM system,
# and provide example use cases for which ANREM has been designed.
#

# get current module path, this can be used later for a number of
# purposes
CURRENT := $(call anrem-current-path)


tgts := $(CURRENT)/hello

obj1 := $(addprefix $(CURRENT)/, hello.o world.o)

obj2 :=  $(addprefix $(CURRENT)/, name.o say.o)

$(call anrem-build, $(tgts)): $(obj1) $(obj2)
	$(CC) -o $@ $^

$(call anrem-clean):
	rm -f $(tgts)
	rm -f $(obj1)
	rm -f $(obj2)

$(call anrem-auto-target, %.o, %.c, $(FALSE), $(obj1))
	gcc -c -o $@ $<
	@echo "group1"

$(call anrem-auto-target, %.o, %.c, $(FALSE), $(obj2))
	gcc -c -o $@ $<
	@echo "group2"
