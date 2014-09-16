#
# This is a template for a module makefile.
# The goal of this file is to show capabilities of the ANREM system,
# and provide example use cases for which ANREM has been designed.
#

## get current module path, this can be used later for a number of
## purposes
CURRENT := $(call anrem-current-path)


tgts := $(CURRENT)/hello

obj1 := $(addprefix $(CURRENT)/, hello.o world.o)

obj2 :=  $(addprefix $(CURRENT)/, name.o say.o)

$(call anrem-target, $(tgts)): $(obj1) $(obj2)
	$(CC) -o $@ $^

$(call anrem-clean):
	rm -f $(tgts)
	rm -f $(obj1)
	rm -f $(obj2)

$(call anrem-target, $(obj2)): %.o: %.c
	$(call anrem-mkdeps, $@, $<)
	gcc -c -o $@ $<
	@echo "group 2"

# custom hook, for signature see anrem-hook-makedepend in mk/hooks.mk
define some_hook =
gcc -MM -MP -MT $1 -MF $2 $3 && echo "custom-hook tgt $(strip $1) file $(strip $2) for $(strip $3)"
endef

$(call anrem-target, $(obj1)): %.o: %.c
	$(call anrem-mkdeps, $@, $<, some_hook)
	gcc -c -o $@ $<
	@echo "group 1"
