#
# Utility functions
#

############## function call utilities

#
# substitutes optional argument with given default if no argumen is given
# @param $1 optarg content
# @param $2 default
anrem-optarg = $(strip $(if $(strip $1),$1,$2))

#
# define an implicit function without arguments
# to be called upon access as $(symbol)
# The implicit function act as a proxy toward another
# function that is called with an arbitrary number of arguments
#
# @param $1 symbol to be defined
# @param $2 function to be called
# @param $3 arguments to the function
#
define anrem-proxy = 
$(eval $1 = $$(call $2, $3))
endef

############### list utils

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

#
# Remove duplicates from list
# @param $1 list variable name
#
define anrem-list-unique =
$(eval $1 := $(sort $($(strip $1))))
endef

############# path operations

#
# removes the last $1 subdirectories from a path
# e.g. anrem-path-tr, 2, my/fancy/path/to/something -> my/fancy/path
# @param $1 number of subdirs to remove from the string
# @param $2 path string
#
define anrem-path-cut = 
$(strip \
$(eval anrem-path-cut-pathlist := $(subst /,$(SPACE),$(call anrem-expand-local, $2)))\
$(eval anrem-path-cut-filter := $(wordlist 1,$(call anrem-expand-local, $1),$(anrem-path-cut-pathlist)))\
$(foreach anrem-path-cut-iter,$(anrem-path-cut-filter),\
	$(eval anrem-path-cut-pathlist := $(anrem-path-cut-pathlist)/)\
	$(eval anrem-path-cut-pathlist := $(patsubst %/,$(NULL),$(anrem-path-cut-pathlist)))\
)\
$(subst $(SPACE),/,$(strip $(anrem-path-cut-pathlist)))\
)
endef

#
# join relative path with absolute path, safe usage outside make rules
# @param $1 module-relative path
# 
anrem-join = $(addprefix $(ANREM_CURRENT_MODULE)/,$(call anrem-expand-local, $1))

#
# Given a file path, return the name of the file (without suffix)
# @param $1 path of the file
# @returns the file name
#
define anrem-path-filename =
$(subst $(dir $(abspath $1)),$(NULL),$(basename $(abspath $1)))
endef

#
# given a file path or directory path return the directory part without
# trailing /
# @param $1 path
#
define anrem-path-dir = 
$(basename $(abspath $1))
endef

#
# Check if a path is contained within another
# @param $1 parent path
# @param $2 path to be tested to see if it is a location within the parent
# @returns $(TRUE) if the path is in the parent path given, $(FALSE) otherwise
#
define anrem-path-is-prefix =
$(strip \
	$(if $(patsubst $(strip $1)%,,$(strip $2)),\
		$(FALSE),\
		$(TRUE)\
	)\
)
endef

#
# Given a path returns a clean path name
# without repeated / and not ending with
# @param $1 the path to evaluate
# @returns a clean path
#
define anrem-path-dir =
$(patsubst %/,%,$(dir $1))
endef


################ Dictionary (associative array)

#
# Utility function to issue parametric get to dict
#
# @param $1 dictionary variable name
# @param $2 dictionary key
# @returns dict[key]
define anrem-dict-get =
$(strip \
	$($(strip $(call anrem-expand-reference, $1))[$(strip $(call anrem-expand-local, $2))])
)
endef

#
# Get all dictionary keys
# The order of the keys is not relevant, do not assume anything.
#
# @param $1 dictionary variable name
# @returns list
define anrem-dict-keys =
$(strip \
	$(foreach anrem-glob-var,$(.VARIABLES),\
		$(if $(filter $(strip $(call anrem-expand-reference, $1))[%],$(anrem-glob-var)),\
			$(lastword \
				$(subst [,$(SPACE), \
					$(patsubst %],%,$(anrem-glob-var))\
				)\
			),\
			$(NULL)\
		)\
	)\
)
endef

#
# Get all dictionary values
# The order of the keys is not relevant, do not assume anything.
#
# @param $1 dictionary variable name
# @returns list
define anrem-dict-items =
$(strip \
	$(foreach __anrem-glob-var,$(.VARIABLES),\
		$(if $(filter $(strip $(call anrem-expand-reference, $1))[%],$(__anrem-glob-var)),\
			$($(__anrem-glob-var)),\
			$(NULL)\
		)\
	)\
)
endef

#
# Check if the dictionary has the given key
# 
# @param $1 the dict variable name
# @param $2 the key to be searched
# @returns $(FALSE) if the key is missing, else return $(TRUE)
define anrem-dict-has-key =
$(strip \
	$(if $(filter $(call anrem-expand-local, $2),$(call anrem-dict-keys,$(call anrem-expand-reference, $1))),\
		$(TRUE),\
		$(FALSE)\
	)\
)
endef

#
# Check if the dictionary has a given value
# 
# @param $1 the dict variable name
# @param $2 the value to look for
# @returns $(TRUE) if found, else $(FALSE)
define anrem-dict-in =
$(strip \
	$(if $(filter $(call anrem-expand-local, $2),$(call anrem-dict-items,$(call anrem-expand-reference, $1))),\
		$(TRUE),\
		$(FALSE)\
	)\
)
endef

#
# Retrun the key for a given content
# 
# @param $1 the dict variable name
# @param $2 the value to look for
# @returns the key(s) associated to the given value or $(NULL)
define anrem-dict-key-for =
$(strip \
	$(foreach anrem-dict-key-for-curr,$(call anrem-dict-keys, $(call anrem-expand-reference, $1)),\
		$(if $(filter $(call anrem-expand-local, $2),$(call anrem-dict-get, $(call anrem-expand-reference, $1), $(anrem-dict-key-for-curr))),\
			$(anrem-dict-key-for-curr),\
			$(NULL)\
		)\
	)\
)
endef
