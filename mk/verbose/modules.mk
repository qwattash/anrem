#########
#
# modules handling functions
# Here are defined the functions that are used to import modules and
# define the module path variables
# 


#
# remove dir calls and use anrem-path-dir instead
#


#
# some constant that are not meant to be 
# configurable by the user
#
ANREM_MOD_PROJECT_FILE := project
ANREM_MOD_SCOPE_FILE := scope
ANREM_MOD_PRIVATE_MK_DIR := mk


#
# Main function that processes the modules
# this function includes the modules and register project namespaces and module variables
# @param $1 a list of paths that are candidate positions for modules
#
define anrem-process-modules =
$(warning main:process DISCOVER NS)\
$(call anrem-ns-discover, $1)\
$(warning main:process DISCOVER MODULES)\
$(call anrem-mod-discover, $1)\
$(warning main:process INCLUDE)\
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
	$(if $(call anrem-mod-check-ignore, $(ANREM_CURRENT_MODULE)),\
		$(eval anrem-include-modules-mk := $(wildcard $(ANREM_CURRENT_MODULE)/*.mk))\
		$(foreach anrem-include-modules-mk-item, $(wildcard $(ANREM_CURRENT_MODULE)/*.mk),\
			$(if $(call anrem-mod-check-file-parse, $(anrem-include-modules-mk-item)),\
				$(eval -include $(anrem-include-modules-mk-item)),\
				$(NOP)\
			)\
		)\
		$(eval -include $(wildcard $(ANREM_CURRENT_MODULE)/$(ANREM_DEPS_DIR)/*.d))\
		,\
		$(NOP)\
	)\
)\
$(eval ANREM_CURRENT_MODULE := $(ANREM_MODULE_END))
endef

#
# retrieve the current path of the module
# useful for defining module targets
define anrem-current-path = 
$(strip	$(ANREM_CURRENT_MODULE))
endef

#
# Check whether the given file should be
# evaluated by the inclusion system or not
# This is used both for inclusion and module name definition
# to avoid that scope files and future files gets in the way
#
# @param $1 the file path
# @returns $(TRUE) if the file should be evaluated, $(FALSE) otherwise
#
define anrem-mod-check-file-parse =
$(strip \
	$(if $(filter $(ANREM_MOD_SCOPE_FILE), $(call anrem-path-filename, $1)),\
		$(FALSE),\
		$(TRUE)\
	)\
)
endef

#
# given a path, check if that path should be ignored
# Currently all paths containing a directory mk with a known subproject as parent
# are ignored (those are added to the ignore path during project discovery)
# To make anrem ignore a path prefix the directory name with _
# @param $1 path to be checked
# @returns $(TRUE) if the module should be evaluated, 
# $(FALSE) if the module shall be ignored
define anrem-mod-check-ignore =
$(strip \
	$(warning mod:check-ignore checking $(strip $1))\
	$(eval anrem-mod-check-ignore-result := $(TRUE))\
	$(foreach anrem-mod-check-ignore-path,$(ANREM_IGNORE_PATH),\
		$(warning mod:check-ignore test against $(anrem-mod-check-ignore-path))\
		$(if $(call anrem-path-is-prefix, $(anrem-mod-check-ignore-path), $1),\
			$(eval anrem-mod-check-ignore-result := $(FALSE)),\
			$(NOP)\
		)\
	)\
	$(warning mod:check-ignore answer: -$(anrem-mod-check-ignore-result)-)\
	$(anrem-mod-check-ignore-result)\
)
endef

#
# given a path, check whether the MOD_x variable referencing the module
# should be created
# Currently all modules registered with anrem-mod-exclude are not exported,
# also modules with their .mk file prefixed with '_' are not exported
#
# @param $1 path to the mk of the module to be checked
# @returns $(TRUE) if the module should be exported, $(FALSE) if not
#

define anrem-mod-check-register =
$(strip \
	$(foreach anrem-mod-check-register-mk, $1,\
		$(if $(call anrem-mod-check-parse, $(anrem-mod-check-register-mk))\
			$(eval anrem-mod-check-register-final-mk := $(anrem-mod-check-register-mk)),\
			$(NOP)\
		)\
	)\
	$(if \
		$(or \
			$(filter $(call anrem-path-dir, $(anrem-mod-check-register-final-mk)), $(ANREM_EXPORTED_MODULES)), \
			$(filter $(call anrem-path-dir, $(anrem-mod-check-register-final-mk)), $(ANREM_EXCLUDE_MODULES))
		)
		,\
		$(FALSE)
		,\
		$(if $(call anrem-ns-is-namespace, $(call anrem-path-dir, $(anrem-mod-check-register-final-mk))),\
			$(warning mod:check-register is NS)\
			$(FALSE)\
			,\
			$(if $(filter _%,$(call anrem-path-filename, $(anrem-mod-check-register-final-mk))),\
				$(call anrem-mod-exclude, $(anrem-mod-discover-module))\
				$(FALSE),\
				$(TRUE)\
			)\
		)\
	)\
)
endef

#
# Get the name of a module given a list of mk files that it contains
# The first file allowed to be parsed defines the name of the module
# If there are multiple allowed files in the module an error is raised
#
# Notice that this does not replace anrem-mod-check-register, this only
# returns the name of the module among multiple choices available, it does not
# decide whether the module should be registered or not
#
# Note also that this function should be called AFTER anrem-mod-check-register
# and anrem-mod-check-ignore to avoid to see the multiple .mk files in the ./mk dir
#
# @param $1 list of mk files in the module
# @returns the name of the module
#
define anrem-mod-get-name =
$(strip \
	$(warning mod:getname looking for name among $1)\
	$(eval anrem-mod-get-name-output := $(NULL))\
	$(foreach anrem-mod-get-name-file, $1,\
		$(warning mod:getname checking $(anrem-mod-get-name-file))\
		$(if $(call anrem-mod-check-file-parse, $(anrem-mod-get-name-file)),\
			$(warning mod:getname check parse OK)\
			$(if $(strip $(anrem-mod-get-name-output)),\
				$(error Multiple mk files for a module: $(strip $1))\
				,\
				$(if $(or \
					$(filter module, $(call anrem-path-filename, $(anrem-mod-get-name-file))),\
					$(filter $(ANREM_MOD_PROJECT_FILE), $(call anrem-path-filename, $(anrem-mod-get-name-file)))\
					),\
					$(eval anrem-mod-get-name-output := $(call anrem-path-filename, $(dir $(anrem-mod-get-name-file))))\
					,\
					$(eval anrem-mod-get-name-output := $(call anrem-path-filename, $(anrem-mod-get-name-file)))\
				)\
			)\
			$(warning mod:getname set output to $(anrem-mod-get-name-output))\
			,\
			$(warning mod:getname check parse FAILED)\
			$(NOP)\
		)\
	)\
	$(anrem-mod-get-name-output)\
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
#	if (ns_modules[projectName] != path):
#		anrem-ns-amend-var(projectName, name, path)
#  else:
#	anrem-ns-add-var(projectName, name, path)
#
define anrem-mod-register =
$(eval anrem-mod-register-name := $(strip $2))\
$(eval anrem-mod-register-ns-name := $(call anrem-ns-for-path, $1))\
$(warning mod:register $(anrem-mod-register-ns-name):$(anrem-mod-register-name))\
$(if $(strip $(anrem-mod-register-ns-name)),\
	$(warning mod:register ENTER state of ns map dict: keys [$(call anrem-dict-keys, $(anrem-mod-register-ns-name))])\
	$(if $(call anrem-dict-has-key, $(anrem-mod-register-ns-name), $(anrem-mod-register-name)),\
		$(if \
			$(filter $(anrem-dict-get, $(anrem-mod-register-ns-name), $(anrem-mod-register-name)),$1)\
			,\
			$(NOP)\
			,\
			$(warning mod:register existing)\
			$(call anrem-ns-amend-var, $(anrem-mod-register-ns-name), $(anrem-mod-register-name), $1),\
		),\
		$(warning mod:register new)\
		$(call anrem-ns-add-var, $(anrem-mod-register-ns-name), $(anrem-mod-register-name), $1)\
	)\
	$(warning mod:register EXIT state of ns map dict: keys [$(call anrem-dict-keys, $(anrem-mod-register-ns-name))])\
	,\
	$(warning mod:register invalid ns!)\
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
	$(eval anrem-mod-discover-mk := $(wildcard $(anrem-mod-discover-module)/*.mk))\
	$(warning mod:discover candidate $(anrem-mod-discover-module) mk $(anrem-mod-discover-mk))\
	$(if $(call anrem-mod-check-ignore, $(anrem-mod-discover-module)),\
		$(if $(call anrem-mod-check-register, $(anrem-mod-discover-mk)),\
			$(eval anrem-mod-discover-name := $(call anrem-mod-get-name, $(anrem-mod-discover-mk)))\
			$(warning mod:discover module name $(anrem-mod-discover-name))\
			$(call anrem-mod-register, $(anrem-mod-discover-module), $(anrem-mod-discover-name))\
			,\
			$(warning mod:discover rejected in register check)\
			$(NOP)\
		),\
		$(warning mod:discover ignored)\
		$(NOP)\
	)\
)
endef


#
# exclude given module from MOD variable generation
# @param $1 module to be excluded
# @deprecated
#
define anrem-mod-exclude = 
$(eval ANREM_EXCLUDE_MODULES = $(sort $(ANREM_EXCLUDE_MODULES) $(strip $1)))
endef

########################### module namespace (subproject handling)
#
# this provides transparent isolation for module variable names in all project and subprojects
#

#
# make anrem inclusion system completely ignore a path
# this path and subpaths are neither defined as module variables
# nor imported
# @param $1 path to ignore
#
define anrem-ns-ignore =
$(eval ANREM_IGNORE_PATH = $(sort $(ANREM_IGNORE_PATH) $(strip $1)))
endef

#
# Get value of a variable in a given namespace
# @param $1 namespace name
# @param $2 variable name
#
define anrem-ns-get =
$($(strip $1)|$(strip $2))
endef

#
# Test if a given path is a known namespace
# @param $1 namespace path
# @returns $(TRUE) if the path is a namespace, $(FALSE) otherwise
#
define anrem-ns-is-namespace =
$(strip \
	$(if $(call anrem-dict-in, ANREM_PROJECTS, $1),\
		$(TRUE),\
		$(FALSE)\
	)\
)
endef

#
# Import scope files from all paths
# The scope files define custom namespaces and 
# ingore paths
#
# IMPORTANT: the scope file is always imported,
# no matter if the path where it is found has been
# added to the ignore list.
#
# @param $1 list of paths to scan
#
define anrem-ns-import-scope =
$(foreach anrem-ns-import-scope-path,$1,\
	$(eval -include $(anrem-ns-import-scope-path)/$(ANREM_MOD_SCOPE_FILE).mk)\
)
endef

#
# Discover projects in the current tree,
# the projects are stored in a dictionary (see anrem-ns-register)
# @param $1 list of module directories to check
#
define anrem-ns-discover =
$(call anrem-ns-import-scope, $1)\
$(foreach anrem-ns-discover-candidate,$(strip $1),\
	$(warning ns:discover candidate $(anrem-ns-discover-candidate))\
	$(eval anrem-ns-discover-mk := $(wildcard $(anrem-ns-discover-candidate)/*.mk))\
	$(warning ns:discover candidate mk $(anrem-ns-discover-mk))\
	$(foreach anrem-ns-discover-mk-candidate, $(anrem-ns-discover-mk),\
		$(if $(filter $(ANREM_MOD_PROJECT_FILE),$(call anrem-path-filename, $(anrem-ns-discover-mk-candidate))),\
			$(call anrem-ns-register, $(anrem-ns-discover-candidate)),\
			$(NOP)\
		)\
	)\
)
endef

#
# Register a subproject in the tree at a given position
# The project is registered in the dictionary ANREM_PROJECTS
#
# @param $1 path subproject directory path
# @param [$2] namespace name to use, defaults to directory name
#
define anrem-ns-register =
$(eval anrem-ns-register-project-name := $(call anrem-optarg,$2,$(call anrem-path-filename, $1)))\
$(warning ns:register registering: $1 with name $(anrem-ns-register-project-name))\
$(if $(filter $(anrem-ns-register-project-name), $(call anrem-dict-keys, ANREM_PROJECTS)),\
	$(if $(filter $(call anrem-dict-get, ANREM_PROJECTS, $(anrem-ns-register-project-name)), $1),\
		$(warning ns:register ns already existing, NOP)\
		$(NOP),\
		$(warning ns:register ns already existing and conflicting)\
		$(call anrem-ns-amend, $(anrem-ns-register-project-name), $1)\
	),\
	$(if $(filter $1, $(call anrem-dict-items, ANREM_PROJECTS)),\
		$(warning ns:register path already registered with another name)\
		$(NOP)\
		,\
		$(warning ns:register new namespace)\
		$(eval ANREM_PROJECTS[$(strip $(anrem-ns-register-project-name))] := $(strip $1))\
		$(call anrem-ns-base-var, $(anrem-ns-register-project-name), $(strip $1))\
		$(call anrem-ns-ignore, $(strip $1)/$(ANREM_MOD_PRIVATE_MK_DIR))\
		$(warning ns:register dump ignore paths: $(ANREM_IGNORE_PATH))\
	)\
)
endef

#
# Define the module base path variable
# The variable is named after the project (ns) name preceded by |
# i.e. namespace = mynamespace the var will be |mynamespace
# @param $1 the namespace name
# @param $2 the namespace path (variable content)
#
define anrem-ns-base-var =
$(eval |$(strip $1) := $(strip $2))
endef

#
# Handle a conflict among two namespace
# names, currently it just give an error
#
# @param $1 namespace name
# @param $2 path that is conflicting with the current name
#
define anrem-ns-amend =
$(error Namespace $1: $(anrem-dict-get, ANREM_PROJECTS, $1) has same name as $(strip $2), change name of the namespace)
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
$(strip \
	$(eval anrem-ns-for-path-candidate := $(NULL))\
	$(warning ns:ns4path checking $1)\
	$(foreach anrem-ns-for-path-item, $(call anrem-dict-items, ANREM_PROJECTS),\
		$(warning ns:ns4path is prefix $(anrem-ns-for-path-item) $1)\
		$(if $(call anrem-path-is-prefix, $(anrem-ns-for-path-item), $1),\
			$(warning true)\
			$(warning ns:ns4path is prefix $(call anrem-dict-get, ANREM_PROJECTS, $(anrem-ns-for-path-candidate)) $(anrem-ns-for-path-item))\
			$(if $(call anrem-path-is-prefix, $(call anrem-dict-get, ANREM_PROJECTS, $(anrem-ns-for-path-candidate)), $(anrem-ns-for-path-item)),\
				$(eval anrem-ns-for-path-candidate := $(strip $(call anrem-dict-key-for, ANREM_PROJECTS, $(anrem-ns-for-path-item)))),\
				$(NOP)\
			),\
			$(NOP)\
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
# @param $3 variable value (module path) that was conflicting with $2
#
define anrem-ns-amend-var =
$(error In namespace $(strip $1): $(call anrem-ns-get, $1, $2) has same name as $(strip $3), change name or declare a namespace)
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
# Remove a module variable from the global scope
# @param $1 project name (namespace)
# @param $2 variable name (module name)
#
#
define anrem-ns-undef-var =
$(eval undefine $(strip $1)|$(strip $2))
endef
