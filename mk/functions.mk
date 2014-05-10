#
# Library functions for inclusion and utilities
#

##################################### utilities

#
# substitutes optional argument with given default if no argumen is given
# @param $1 optarg content
# @param $2 default
anrem-optarg = $(if $(1),$(1),$(2))

##################################### modules handling

#
# include given modules, this function MUST be used to include
# the project modules
# @param $1 list of modules to be included
anrem-include-modules = $(foreach ANREM_CURRENT_MODULE,$(1),$(eval -include $(wildcard $(ANREM_CURRENT_MODULE)/*.mk)))

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

# comments can not be done inside the define so deal with it!
# Instead I'll give pseudocode, you're welcome..
# void anrem-def-modx(path, [custom_name=NULL]):
# if (not path in EXPORTED_MODULES):
# 	// if no custom name is given, use the module directory name
# 	// otherwise use the given custom name
#	if (custom_name == NULL):
#		words = split('/', path)
#		name = words.last()
# 	else:
# 		name = custom_name
#	// module not yet exported, try to create MOD variable
# 	if (name in MOD_VAR_NAMES):
#		//conflicting module
#		rename old conflicting module MOD var to a longer name
#		use longer name to create MOD var for the current module
#		set the value for the new module var
#		add new module var name to MOD_VAR_NAMES
#		add path to EXPORTED_MODULES
#	else:
#		// new module, create MOD variable normally
#		create MOD var using just the module name
#		add new module var name to MOD_VAR_NAMES
#		add path to EXPORTED_MODULES
# 
# Secondly get the name of the module into a variable used locally
# Then check again for the name of the module inside the exported paths
# if the name is found, this is a problem! Notify the user with a warning and rename both modules' MOD_x var
# by appending the 
# else everything ok, export the MOD_x var as normal
define anrem-def-modx =
$(if $(filter $1,$(EXPORTED_MODULES)),,\
	$(eval anrem-def-modx-name := $(call anrem-optarg,$(strip $2),$(subst $(dir $1),,$1)))\
	$(eval EXPORTED_MODULES += $1)\
	$(if $(filter $(anrem-def-modx-name),$(MOD_VAR_NAMES)),\
		$(eval anrem-def-modx-duplicate := $(MOD_$(anrem-def-modx-name)))\
		$(warning Found modules with same name: $(strip $1), $(anrem-def-modx-duplicate).\
	 		Conflict has been resolved automatically,\
			however consider declaring module variables manually as shown in the docs.)\
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
	)\
)
endef

#
# generate MOD_x variables for each module path in the given list
# @param $1 list of paths for which the MOD variables have to be
# defined
#
#anrem-export-modules = $(foreach _MODULE,$1,$(call anrem-def-modx,$(_MODULE)))

#
# generate MOD_x variables for each module path in the given list
# the MOD variables are named in the following way:
# i) the module "*.mk" is named "module.mk" -> use automatic module name resolution (see anrem-def-modx)
# ii) the moduel "*.mk" is named starting with an underscore "_" (such as "_module.mk") the module is ignored
#	(see anrem-exclude-modx)
# iii) the module "*.mk" is named with some other name (such as "custom.mk") the module MOD variable will
#	be named after the "*.mk" name (in this case MOD_custom) provided that the name is not already in use
# @param $1 list of modules to inspect
#
define anrem-export-modules = 
$(foreach _MODULE,$(1),\
	$(eval anrem-export-modules-mk := $(subst $(SPACE),_,$(wildcard $(_MODULE)/*.mk)))\
	$(eval anrem-export-modules-name := $(subst $(dir $(anrem-export-modules-mk)),,$(basename $(anrem-export-modules-mk))))\
	$(if $(filter module,$(anrem-export-modules-name)),\
		$(call anrem-def-modx, $(_MODULE))\
	,\
		$(if $(filter _%,$(anrem-export-modules-name)),\
			$(call anrem-exclude-modx,$(_MODULE))\
		,\
			$(call anrem-def-modx, $(_MODULE), $(anrem-export-modules-name))\
		)\
	)\
)
endef


#
# exclude given module from MOD variable generation
# @param $1 module to be excluded
#
anrem-exclude-modx = $(eval EXPORTED_MODULES += $1)

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
