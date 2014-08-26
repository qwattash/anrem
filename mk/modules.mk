#########
#
# modules handling functions
# Here are defined the functions that are used to import modules and
# define the module path variables
# 

#
# Main function that processes the modules
# this function includes the modules and register project namespaces and module variables
# @param $1 a list of paths that are candidate positions for modules
#
define anrem-process-modules =
$(call anrem-ns-discover, $1)\
$(call anrem-mod-discover, $1)\
$(call anrem-include-modules, $1)
endef


# logic of the anrem inclusion system

########################### module inclusion
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

######################################################################################################################## old mod var API

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
#
# void anrem-def-modx(path, [custom_name=NULL]):
# if (not path in EXPORTED_MODULES and not path in EXCLUDE_MODULES):
# 	// if no custom name is given, use the module directory name
# 	// otherwise use the given custom name
#	if (custom_name == NULL):
#		words = path.split('/')
#		name = words.last()
# 	else:
# 		name = custom_name
#	// module not yet exported, register it
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
# @refactor
define anrem-mod-var =
$(if $(or $(filter $1,$(ANREM_EXCLUDE_MODULES)), $(filter $1,$(ANREM_EXPORTED_MODULES))),\
	$(NOP)\
	,\
	$(eval anrem-def-mod-var-name := $(call anrem-optarg,$(strip $2),$(call anrem-path-filename, $1)))\
	$(eval ANREM_EXPORTED_MODULES += $1)\
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
########################################################################################################################

#
# given a path, check if that path should be ignored
# Currently all paths containing a directory mk with a known subproject as parent
# are ignored
# To make anrem ignore a path prefix the directory name with _
# @param $1 path to be checked
# @returns $(TRUE) if the module should be evaluated, 
# $(FALSE) if the module shall be ignored
# @todo
define anrem-mod-check-ignore =
endef

#
# given a path, check whether the MOD_x variable referencing the module
# should be created
# Currently all modules registered with anrem-mod-exclude are not exported,
# also modules with their .mk file prefixed with '_' are not exported
#
# @param $1 path to be checked
# @returns $(TRUE) if the module should be exported, $(FALSE) if not
#
define anrem-mod-check-register =
$(strip \
	$(if $(or $(filter $(dir $1), $(ANREM_EXPORTED_MODULES)),$(filter $(dir $1), $(ANREM_EXCLUDE_MODULES))),\
		$(FALSE),\
		$(if $(filter _%,$(call anrem-path-filename, $1)),\
			$(FALSE),\
			$(TRUE)
		)\
	)\
)
endef

#
# Register a module within its namespace, namespace is discovered from
# the module path
# @param $1 path module path to be registered
# @param [$2=<dir_name>] name of the module, defaults to the name of the directory
#
# Pseudocode.
#
# void anrem-mod-register(path, module):
#  if (! name): 
#	name = path.split("/").last()
#  projectName = anrem-ns-for-path(path)
#  if (name in ns_modules[projectName]):
#	anrem-ns-amend-var(projectName, name)
#  else:
#	anrem-ns-add-var(projectName, name)
#
define anrem-mod-register =
$(eval anrem-mod-register-name := $(call anrem-optarg,$(strip $2),$(call anrem-path-filename, $1)))\
$(eval anrem-mod-register-ns-name := $(call anrem-ns-for-path, $1))\
$(info register $(anrem-mod-register-ns-name)|$(anrem-mod-register-name) => $1)\
$(if $(strip $(anrem-mod-register-ns-name)),\
	$(if $(filter $(anrem-mod-register-name),$(ANREM_NS_MODULES[$(anrem-mod-register-ns-name)])),\
		$(call anrem-ns-amend-var, $(anrem-mod-register-ns-name), $(anrem-mod-register-name)),\
		$(call anrem-ns-add-var, $(anrem-mod-register-ns-name), $(anrem-mod-register-name), $1)\
	),\
	$(NOP)\
)
endef

#
# generate discover modules to be registerd for each candidate path in the given list
# Paths are handled in the following way:
# i) any path not containing a file *.mk is discarded
# ii) if the path contains a file named module.mk or project.mk it is registered with its
# directory name as module name
# iii) if the path contains a file named differently from (ii), it is registered with the
# *.mk file name as module name
# iv) if the path contains a file recognised to be marked as excluded, the module is not
# registered but still included (see mod-ignore for inclusion related controls)
# @param $1 list of modules to inspect
#
define anrem-mod-discover = 
$(foreach anrem-mod-discover-module, $1,\
	$(eval anrem-mod-discover-mk := $(word 1,$(wildcard $(anrem-mod-discover-module)/*.mk)))\
	$(eval anrem-mod-discover-name := $(call anrem-path-filename, $(anrem-mod-discover-mk)))\
	$(if $(call anrem-mod-check-register, $(anrem-mod-discover-mk)),\
		$(if $(or $(filter module,$(anrem-mod-discover-name)),$(filter project,$(anrem-mod-discover-name))),\
			$(call anrem-mod-register, $(anrem-mod-discover-module)),\
			$(call anrem-mod-register, $(anrem-mod-discover-module), $(anrem-mod-discover-name))\
		),\
		$(call anrem-mod-exclude, $(anrem-mod-discover-module))\
	)\
)
endef


#
# exclude given module from MOD variable generation
# @param $1 module to be excluded
# @deprecated
#
define anrem-mod-exclude = 
$(eval ANREM_EXPORTED_MODULES += $1)\
$(eval ANREM_EXCLUDE_MODULES = $(sort $(ANREM_EXCLUDE_MODULES) $(strip $1)))
endef


########################### module namespace (subproject handling)
#
# this provides transparent isolation for module variable names in all project and subprojects
#

#
# Discover projects in the current tree,
# the projects are stored in a dictionary (see anrem-ns-register)
# @param $1 list of module directories to check
#
define anrem-ns-discover =
$(foreach anrem-ns-discover-candidate,$(strip $1),\
	$(eval anrem-ns-discover-mk := $(word 1,$(wildcard $(anrem-ns-discover-candidate)/*.mk)))\
	$(if $(filter project,$(call anrem-path-filename, $(anrem-ns-discover-mk))),\
		$(call anrem-ns-register, $(anrem-ns-discover-candidate)),\
		$(NULL)\
	)\
)
endef

#
# Register a subproject in the tree at a given position
# The project is registered in the dictionary ANREM_PROJECTS
#
# @param $1 path subproject directory path
#
define anrem-ns-register =
$(eval anrem-ns-register-project-name := $(call anrem-path-filename, $1))\
$(eval ANREM_PROJECTS[$(strip $(anrem-ns-register-project-name))] := $(strip $1))
endef

#
# Get project namespace to which a given module path
# belongs to.
# In case of multiple matches, the namespace with the more specific (longest matching) path
# is chosen.
# @param $1 path to be tested
# @retruns a namespace name
#
define anrem-ns-for-path =
$(eval anrem-ns-for-path-candidate := $(NULL))\
$(foreach anrem-ns-for-path-item, $(call anrem-dict-items, ANREM_PROJECTS),\
	$(if $(patsubst $(anrem-ns-for-path-item)%,,$(strip $1)),\
		$(NOP),\
		$(if $(patsubst $(ANREM_PROJECTS[$(anrem-ns-for-path-candidate)])%,,$(strip $1)),\
			$(NOP),\
			$(eval anrem-ns-for-path-candidate := $(strip $(call anrem-dict-key-for, ANREM_PROJECTS, $(anrem-ns-for-path-item))))\
		)\
	)\
)\
$(strip $(anrem-ns-for-path-candidate))
endef

#
# Register a in a namespace, the name will be marked as used and any 
# attempt to reuse it will be marked as module name clash
# @param $1 project name (i.e. the namespace name)
# @param $2 variable name to be registered
# @param $3 variable value (path to the module)
#
define anrem-ns-add-var =
$(eval $(strip $1)[$(strip $2)] := $(strip $3))\
$(call anrem-ns-def-var, $1, $2, $3)
endef

#
# Amend the registration of a variable, when a module name clash
# is detected, the conflicting names are changed according to the 
# following rules to make them unique inside their namespaces.
# The modules are then registered with different names.
# @param $1 project name (i.e. namespace name)
# @param $2 variable name to be modified
#
define anrem-ns-amend-var =
endef

#
# Export a module variable to the global scope
# @param $1 project name (namespace)
# @param $2 variable name (module name)
# @param $3 variable value (module path)
#
define anrem-ns-def-var =
$(eval $(strip $1)|$(strip $2) := $(strip $3))
endef

#
# Remove a module variable to the global scope
# @param $1 project name (namespace)
# @param $2 variable name (module name)
#
#
define anrem-ns-undef-var =
endef
