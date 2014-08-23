#########
#
# modules handling functions
# Here are defined the functions that are used to import modules and
# define the module path variables
# 

##################################### modules handling

#
# include given modules, this function MUST be used to include
# the project modules
# at the end the variable is set to a known value indicating that
# inclusion have finished
# @param $1 list of modules to be included
define anrem-include-modules = 
$(foreach ANREM_CURRENT_MODULE,$1,\
	$(eval -include $(word 1,$(wildcard $(ANREM_CURRENT_MODULE)/*.mk)))\
	$(eval -include $(wildcard $(ANREM_CURRENT_MODULE)/$(ANREM_DEPS_DIR)/*.d))\
)\
$(eval ANREM_CURRENT_MODULE := $(ANREM_MODULE_END))
endef

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
define anrem-mod-var =
$(if $(filter $1,$(EXPORTED_MODULES)),,\
	$(eval anrem-def-mod-var-name := $(call anrem-optarg,$(strip $2),$(subst $(dir $1),,$1)))\
	$(eval EXPORTED_MODULES += $1)\
	$(if $(filter $(anrem-def-mod-var-name),$(MOD_VAR_NAMES)),\
		$(eval anrem-def-mod-var-duplicate := $(MOD_$(anrem-def-mod-var-name)))\
		$(warning Found modules with same name: $(strip $1), $(anrem-def-mod-var-duplicate).\
	 		Conflict has been resolved automatically,\
			however consider declaring module variables manually as shown in the docs.)\
		$(eval undefine MOD_$(anrem-def-mod-var-name))\
		$(eval MOD_VAR_NAMES := $(filter-out $(anrem-def-mod-var-name),$(MOD_VAR_NAMES)))\
		$(eval anrem-def-mod-var-duplicate-name := $(subst /,_,$(anrem-def-mod-var-duplicate)))\
		$(eval anrem-def-mod-var-name := $(subst /,_,$1))\
		$(eval MOD_$(anrem-def-mod-var-name) := $1)\
		$(eval MOD_$(anrem-def-mod-var-duplicate-name) := $(anrem-def-mod-var-duplicate))\
		$(eval MOD_VAR_NAMES += $(anrem-def-mod-var-name))\
		$(eval MOD_VAR_NAMES += $(anrem-def-mod-var-duplicate-name))\
	,\
		$(eval MOD_$(anrem-def-mod-var-name) := $1)\
		$(eval MOD_VAR_NAMES += $(anrem-def-mod-var-name))\
	)\
)
endef

#
# generate MOD_x variables for each module path in the given list
# the MOD variables are named in the following way:
# i) the module "*.mk" is named "module.mk" -> use automatic module name resolution (see anrem-def-mod-var)
# ii) the moduel "*.mk" is named starting with an underscore "_" (such as "_module.mk") the module is ignored
#	(see anrem-exclude-mod-var)
# iii) the module "*.mk" is named with some other name (such as "custom.mk") the module MOD variable will
#	be named after the "*.mk" name (in this case MOD_custom) provided that the name is not already in use
# @param $1 list of modules to inspect
#
define anrem-mod-export = 
$(foreach _MODULE,$(1),\
	$(eval anrem-mod-export-mk := $(subst $(SPACE),_,$(word 1,$(wildcard $(_MODULE)/*.mk))))\
	$(eval anrem-mod-export-name := $(subst $(dir $(anrem-mod-export-mk)),,$(basename $(anrem-mod-export-mk))))\
	$(if $(filter module,$(anrem-mod-export-name)),\
		$(call anrem-mod-var, $(_MODULE))\
	,\
		$(if $(filter _%,$(anrem-mod-export-name)),\
			$(call anrem-mod-exclude,$(_MODULE))\
		,\
			$(call anrem-mod-var, $(_MODULE), $(anrem-mod-export-name))\
		)\
	)\
)
endef


#
# exclude given module from MOD variable generation
# @param $1 module to be excluded
#
anrem-mod-exclude = $(eval EXPORTED_MODULES += $1)
