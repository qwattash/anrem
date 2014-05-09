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
#$(call anrem-def-modx, test_src/calc/main, cmain)
#$(call anrem-def-modx, test_src/main, main)

MOD_VAR_NAMES := $(NULL)
# comments can not be done inside the define so deal with it!
# First of all check whether the path has already been seen by the export function, if not go on, else NOP
# Secondly get the name of the module into a variable used locally
# Then check again for the name of the module inside the exported paths
# if the name is found, this is a problem! Notify the user with a warning and rename both modules' MOD_x var
# by appending the 
# else everything ok, export the MOD_x var as normal

define anrem-def-modx-dbg1 =
$(eval anrem-def-modx-name := $(call anrem-optarg,$(strip $2),$(subst $(dir $1),,$1)))\
$(if $(findstring $(anrem-def-modx-name),$(MOD_VAR_NAMES)),\
	$(eval anrem-def-modx-duplicate := $(MOD_$(anrem-def-modx-name)))\
	$(warning found modules with same name: $(strip $1), $(anrem-def-modx-duplicate).\
	 	Consider assigning MOD variable manually)\
	$(eval undefine MOD_$(anrem-def-modx-name))\
	$(eval MOD_VAR_NAMES := $(filter-out $(anrem-def-modx-name),$(MOD_VAR_NAMES)))\
	$(eval anrem-def-modx-duplicate-name := $(subst /,_,$(anrem-def-modx-duplicate)))\
	$(eval anrem-def-modx-name := $(subst /,_,$1))\
	$(eval MOD_$(anrem-def-modx-name) := $1)\
	$(eval MOD_$(anrem-def-modx-duplicate-name) := $(anrem-def-modx-duplicate))\
	$(eval MOD_VAR_NAMES += $(anrem-def-modx-name))\
	$(eval MOD_VAR_NAMES += $(anrem-def-modx-duplicate-name))\
,\
	$(eval MOD_$(anrem-def-modx-name) := $1)\
	$(eval MOD_VAR_NAMES += $(anrem-def-modx-name))\
)
endef

$(call anrem-def-modx-dbg1, a/b/cc/dd)
$(info -$(EXPORTED_MODULES)-)
$(info -$(MOD_dd)-)
$(call anrem-def-modx-dbg1, a/b/xx/dd)
$(info -$(EXPORTED_MODULES)-)
$(info -$(MOD_dd)-)
$(info -$(MOD_a_b_xx_dd)-)
$(info -$(MOD_a_b_cc_dd)-)
