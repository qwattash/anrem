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


#%.o: %.c
#-include $(wildcard src/test_auto_deps/.deps/*.d)
#src/test_auto_deps/.deps/%.mkdep: src/test_auto_deps/%.c
#	@mkdir -p src/test_auto_deps/.deps
##	$(call anrem-hook-makedepend, src/test_auto_deps/$*.o,src/test_auto_deps/$(lastword $(subst /, ,$*)).d, $<)
#	gcc -MM -MP -MT $@ -MF $(path)/.deps/$*.d $<
#
#src/test_auto_deps/%.o: src/test_auto_deps/%.c src/test_auto_deps/.deps/%.mkdep
#	gcc -c -o $@ $<
#	@echo "custom_rule"


############ ################### #################### ##############
#CURRENT := $(call anrem-current-path)
#
#all: $(CURRENT)/hello
#
#obj1 := $(addprefix $(CURRENT)/, hello.o world.o)
#
#obj2 :=  $(addprefix $(CURRENT)/, name.o say.o)
#
#$(call anrem-build, $(CURRENT)/hello): $(obj1) $(obj2)
#	gcc -o $@ $^
#
#$(call anrem-clean):
##	rm -f $(path)/.deps/*.d
#	rm -f $(path)/*.o
#	rm -f $(path)/hello
##       rm -f $(CURRENT)/.deps/*.mkdep
#
## $1 target pattern
## $2 src pattern
#define suppress-rule =
#$(strip $1): $(strip $2)
#endef
#
## $1 target pattern
## $2 src pattern
#define mkdep-rule =
#$(call anrem-current-path)/$(ANREM_DEPS_DIR)/%.mkdep: $(call anrem-current-path)/$(strip $2)
#	@mkdir -p $(call anrem-current-path)/$(ANREM_DEPS_DIR)
#	$(call mkdepend-hook,\
#		$(call anrem-current-path)/$$*$(suffix $1),\
#		$(call anrem-current-path)/$(ANREM_DEPS_DIR)/$$*.d,\
#		$$<\
#	)
#endef
#
## $1 target pattern
## $2 src pattern
## $3 scope list
#define default-rule =
#$(if $(strip $3), $(strip $3):)\
#$(call anrem-current-path)/$(strip $1): $(call anrem-current-path)/$(strip $2) $(call anrem-current-path)/$(ANREM_DEPS_DIR)/%.mkdep
#	gcc -c -o $$@ $$<
#	@echo "default rule"
#endef
#
## $1 target pattern
## $2 src pattern
## $3 scope list
#define custom-rule =
#$(if $(strip $3), $(strip $3):)\
#$(call anrem-current-path)/$(strip $1): $(call anrem-current-path)/$(strip $2) $(call anrem-current-path)/$(ANREM_DEPS_DIR)/%.mkdep
#endef
#
## $1 target name
## $2 dependency file
## $3 soruce file
#define mkdepend-hook =
#gcc -MM -MP -MT $(strip $1) -MF $(strip $2) $(strip $3)
#endef
#
## $1 target pattern
## $2 src pattern
## $3 custom/default rule (True/False)
## $4 scope list or NULL
#define main =
#$(eval -include $(wildcard $(call anrem-current-path)/$(ANREM_DEPS_DIR)/*.d))\
#$(call anrem-deps-clean)\
#$(eval $(call suppress-rule, $1, $2))\
#$(eval $(call mkdep-rule, $1, $2, $4))\
#$(if $(strip $3),\
#	$(info $(call custom-rule, $1, $2, $4)),\
#	$(eval $(call default-rule, $1, $2, $4))\
#)
#endef
#
#$(call main, %.o, %.c, $(TRUE), $(obj1))
##	gcc -c -o $@ $<
##	@echo "custom rule 1"
#
#$(call main, %.o, %.c, $(TRUE), $(obj2))
##	gcc -c -o $@ $<
##	@echo "custom rule 2"
