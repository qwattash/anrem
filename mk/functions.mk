#
# Library functions for inclusion and utilities
#

##################################### utilities

#
# substitutes optional argument with given default if no argumen is given
# @param $1 optarg content
# @param $2 default
anrem-optarg = $(strip $(if $(1),$(1),$(2)))

#
# reverse a list
# @param $1 list to be reversed
#
define anrem-list-reverse = 
$(strip \
$(eval anrem-list-reverse-out := $(NULL))\
$(foreach anrem-list-reverse-item,$1,\
	$(eval anrem-list-reverse-out := $(strip $(anrem-list-reverse-item) $(anrem-list-reverse-out)))\
)\
$(anrem-list-reverse-out)\
)
endef

##################################### modules handling

#
# include given modules, this function MUST be used to include
# the project modules
# @param $1 list of modules to be included
anrem-include-modules = $(foreach ANREM_CURRENT_MODULE,$(1),$(eval -include $(word 1,$(wildcard $(ANREM_CURRENT_MODULE)/*.mk))))

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

##################################### target handling

#
# declare a target and add given it to the global targets list
# that is executed when make all is run
# @param $1 target
#
define anrem-build =
$(strip \
$(call anrem-target, $1)\
$(eval ANREM_BUILD_TARGETS += $(strip $1))\
)
endef
#
# declare a clean target and add given target to the clean list
# that is executed whenever make clean is issued
# If the target name is omitted one is automatically generated
# @param $1 target
#
define anrem-clean = 
$(strip \
$(call anrem-target, $(call anrem-optarg,$1,clean_$(call anrem-current-path)))\
$(eval ANREM_BUILD_CLEAN += $(strip $(call anrem-optarg,$1,clean_$(call anrem-current-path))))\
)
endef

#
# add a target to the test targets list, the list is meant to hold
# targets used to build unit-tests or other testing code
# @param $1 the target to add to the list
#
define anrem-test = 
$(strip \
$(call anrem-target, $(call anrem-optarg,$1,test_$(call anrem-current-path)))\
$(eval ANREM_TEST_TARGETS += $(strip $(call anrem-optarg,$1,test_$(call anrem-current-path))))\
)
endef

#
# define the local path for a given target
# @param $1 target for which the path is defined
#
anrem-target-defpath = $(eval $1: path:=$(ANREM_CURRENT_MODULE))

#
# declare a target in the current module path.
# This does not add the target to any anrem target list.
# @param $1 target absolute name
#
anrem-target = $(strip $1)$(call anrem-target-defpath, $(strip $1))

############################################# path handling

#
# removes the last $1 subdirectories from a path
# e.g. anrem-path-tr, 2, my/fancy/path/to/something -> my/fancy/path
# @param $1 number of subdirs to remove from the string
# @param $2 path string
#
define anrem-path-cut = 
$(strip \
$(eval anrem-path-cut-pathlist := $(subst /,$(SPACE),$(strip $2)))\
$(eval anrem-path-cut-filter := $(wordlist 1,$1,$(anrem-path-cut-pathlist)))\
$(foreach anrem-path-cut-iter,$(anrem-path-cut-filter),\
	$(eval anrem-path-cut-pathlist := $(anrem-path-cut-pathlist)/)\
	$(eval anrem-path-cut-pathlist := $(patsubst %/,$(NULL),$(anrem-path-cut-pathlist)))\
)\
$(subst $(SPACE),/,$(strip $(anrem-path-cut-pathlist)))\
)
endef

#
# Local variables utility, this can be used to declare and access
# local variables
# @param $1 symbol name
#
anrem-local = $(strip $1_$(call anrem-current-path))

#
# Local variables utility, store the given value in given local var
# @param $1 local symbol name
# @param $2 value to store
#
anrem-local-set = $(eval $(call anrem-local, $1) := $2)

#
# Local variables utility, get the value of a given local var
# @param $1 local symbol name
#
anrem-local-get = $($(call anrem-local, $1))

#
# join relative path with absolute path, safe usage outside make rules
# @param $1 module-relative path
# 
anrem-join = $(addprefix $(ANREM_CURRENT_MODULE)/,$(strip $(1)))
