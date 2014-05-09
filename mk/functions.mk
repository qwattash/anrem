#
# Library functions for inclusion and utilities
#

##################################### utilities

#
# substitutes optional argument with given default if no argumen is given
# @param $1 optarg content
# @param $2 default
anrem-optarg = $(subst $(NULL),$(2),$(1))

##################################### modules handling

#
# include given modules, this function MUST be used to include
# the project modules
# @param $1 list of modules to be included
anrem-include-modules = $(foreach ANREM_CURRENT_MODULE,$(1),$(eval -include $(ANREM_CURRENT_MODULE)/module.mk))

#
# retrieve the current path of the module
# useful for defining module targets
anrem-current-path = $(ANREM_CURRENT_MODULE)

#
# export path of the module to the global variable MOD_<module_name>
# this is useful when compiling and linking object files and .h from
# other modules which may move in the code tree
# This function allows flawless refactoring capabilities at
# package granularity with absolutely no change in the makefiles as long
# as the file names and final module names are not changed.
# As an extension to limit the effect of a changing module name it can be passed
# the name to use as argument to this function.
# This function is equivalent to is $MOD_mymodule := $(call anrem-current-path)
# when no name clashes occur
# @param $1 module path
# @param $2 optional name of the module to use
#

# the variable might be moved somewhere else?
MOD_VAR_NAMES := $(NULL)
# comments can not be done inside the define so deal with it!
# First of all check whether the path has already been seen by the export function, if not go on, else NOP
# Secondly get the name of the module into a variable used locally
# Then check again for the name of the module inside the exported paths
# if the name is found, this is a problem! Notify the user with a warning and rename both modules' MOD_x var
# by appending the 
# else everything ok, export the MOD_x var as normal

define anrem-def-modx =
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


# old implementation, now deprecated
# anrem-def-modx = $(eval MOD_$(call anrem-optarg,$(strip $2),$(subst $(dir $1),,$1)) := $1)

#
# generate MOD_x variables for each module path in the given list
#
anrem-export-modules = $(foreach _MODULE,$1,$(call anrem-def-modx,$(_MODULE)))


##################################### target handling

#
# add given target to the global targets list
# that is executed when make all is run
#
anrem-build = $(eval ANREM_BUILD_TARGETS += $(strip $(1)))

#
# add given target to the clean list
# that is executed whenever make clean is issued
#
anrem-clean = $(eval ANREM_BUILD_CLEAN += $(strip $(1)))

#
# define the local path for a given target
# @param $1 target for which the path is defined
#
anrem-target-defpath = $(eval $(1): path:=$(ANREM_CURRENT_MODULE))

#
# define a target relative to current path
# @param $1 target absolute name
#
anrem-target = $(strip $(1))$(call anrem-target-defpath, $(strip $(1)))

############################################# path handling

#
# join relative path with absolute path, safe usage outside make rules
# @param $1 module-relative path
# 
anrem-join = $(addprefix $(ANREM_CURRENT_MODULE)/,$(strip $(1)))
