BUILDDIR := test_src/build

# custom module variables for modules with the same name
# for instance test_src/main and test_src/calc/main would
# end up in the same variable MOD_main
# this is unfortunate since the behaviour for selecting the
# real content of MOD_main is undetermined.
# A solution could be detecting such conflicts and automatically
# use a different name such as MOD_calc_main and MOD_test_src_main:
# this is the default behaviour of ANREM in order to avoid name
# clashed on the module naming.
# However you may argue that the naming is cumbersome and it is also
# undetermined in the sense that in theory long names can result up
# to the full path of the module, making the whole thing useless;
# also this makes the NAME dependant on the PATH, an this is
# the thing that we wanted to avoid in the first place.
# To fix this the user is given the opportunity (and is strongly encouraged)
# to define himself the variables for conflicting modules in the project.mk
# as follows.
$(call anrem-def-modx, test_src/calc/main, custom)

# for some other reasons, and because of name clashes you may want to ignore the
# generation of MOD variables for some modules, this can be done by
#$(call anrem-exclude-modx, test_src/calc/main)


# experimental MOD variable definition based on module.mk name
define anrem-def-modx-exp = 
$(foreach _MODULE,$(ANREM_MODULES),\
	$(eval anrem-def-modx-exp := $(wildcard $(_MODULE)/%.mk))\
	$(eval anrem-def-modx-name := $(subst $(dir $(anrem-def-modx-exp)),,$(basename $(anrem-def-modx-exp))))\
	$(if $(filter module,$(anrem-def-modx-name)),\
		$(call anrem-def-modx, $(_MODULE))\
	,\
		$(call anrem-def-modx, $(_MODULE), $(anrem-def-modx-name))\
	)\
)
endef

#$(call anrem-def-modx-exp)
#$(info $(EXPORTED_MODULES))
#$(info $(MOD_VAR_NAMES))

#$(error dbg)
