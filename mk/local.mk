##########
#
# local variables
# Here are defined the functions that manage module local variables
# and expansion of the local variable tags
#

#
# Expand a local variable beginning by @ (by default, see mk/tags.mk), if possible
# otherwise return the same text given as input
# such as @mylocalvar
# @param $1 local variable name or normal text
#
define anrem-expand-local = 
$(strip \
	$(if $(filter $(ANREM_LOCAL_TAG_GET)%,$(strip $1)),\
		$(call anrem-local-get, $(patsubst $(ANREM_LOCAL_TAG_GET)%,%,$(strip $1))),\
		$(strip $1)
	)\
)
endef

#
# For a local variable beginning by @ (by default, see mk/tags.mk), 
# return its local name if possible;
# otherwise return the same text given as input
# such as @mylocalvar -> __local_prefix__mylocalvar
#
# @param $1 local variable name or normal text
#
define anrem-expand-reference = 
$(strip \
	$(if $(filter $(ANREM_LOCAL_TAG_GET)%,$(strip $1)),\
		$(call anrem-local, $(patsubst $(ANREM_LOCAL_TAG_GET)%,%,$(strip $1))),\
		$(strip $1)
	)\
)
endef

#
# Local variables utility, this can be used to declare and access
# local variables, this works inside the target rules too
# @param $1 symbol name
#
define anrem-local = 
$(strip $(strip $(call anrem-local-get-prefix))_$(strip $1))
endef

#
# Helper for anrem-local, gives the current path
# from both inside a target rule and outside.
define anrem-local-get-prefix =
__local_$(strip \
	$(if $(filter $(ANREM_MODULE_END),$(call anrem-current-path)),
		$(path),\
		$(call anrem-current-path)\
	)\
)
endef

#
# Local variables utility, store the given value in given local var
# a proxy variable is also defined to get the local variable
# @param $1 local symbol name
# @param $2 value to store
#
define anrem-local-set = 
$(eval $(call anrem-local, $1) := $2)\
$(call anrem-local-def-proxy, $1)
endef

#
# Local variables utility, get the value of a given local var
# @param $1 local symbol name
# @returns the variable value
#
define anrem-local-get = 
$($(call anrem-local, $1))
endef

#
# Create a proxy symbol to access a local variable in
# the current scope
# @param $1 local symbol name
#
define anrem-local-def-proxy =
$(call anrem-proxy, $(strip $(ANREM_LOCAL_TAG_GET))$(strip $1), anrem-local-get, $1)
endef

## shorthand method for anrem-local-set and get

#
# The idea is to define a block of local variables as
# The tags (the thingy inside the $(..) stuff) is configurable from mk/tags.mk 
#
#
# $(!@) # start of local definition block
# $(@)myvar_1 := something
# $(@)myvar_2 := other_stuff
# $(@!) # end of local definition block, from now on can use $(@myvar_1)
#

#
# Shorthand version for anrem-local-set,
# define the start of a local variable block
#
define $(ANREM_LOCAL_TAG_BLK_START) =
$(eval anrem-local-snapshot := $(sort $(.VARIABLES) anrem-local-snapshot))
endef

#
# short version of anrem-local-set, in practice
# this is used to the the local prefix for a variable like
#
# @returns the variable local prefix
#
define $(ANREM_LOCAL_TAG_SET) =
$(strip $(strip $(call anrem-local-get-prefix))_)
endef

#
# Shorthand version for anrem-local-set,
# define the end of a local variable block
#
define $(ANREM_LOCAL_TAG_BLK_END) =
$(strip \
	$(foreach anrem-local-blk-end,$(.VARIABLES),\
		$(if $(filter $(anrem-local-blk-end),$(anrem-local-snapshot)),
			$(NOP),\
			$(call anrem-local-def-proxy, $(subst $(call anrem-local-get-prefix)_,,$(anrem-local-blk-end)))\
		)\
	)\
)
endef

####### Implementation of project-local variables

#
# Namespace local variables utility, this can be used to declare and access
# local variables in a namespace, this works inside the target rules too
# @param $1 symbol name
#
define anrem-ns-local = 
$(strip $(strip $(call anrem-ns-local-get-prefix))_$(strip $1))
endef

#
# Helper for anrem-local, gives the current path
# from both inside a target rule and outside.
define anrem-ns-local-get-prefix =
__nslocal_$(strip \
	$(if $(filter $(ANREM_MODULE_END),$(call anrem-current-path)),
		$(call anrem-ns-for-path, $(path)),\
		$(call anrem-ns-for-path, $(call anrem-current-path))\
	)\
)
endef


#
# Set a local variable with namespace scope
# @param $1 the name of the variable
# @param $2 the value of the variable
#
define anrem-ns-local-set =
$(eval $(call anrem-ns-local, $1) := $(strip $2))\
$(call anrem-ns-local-def-proxy, $1)
endef

#
# Set a local variable with namespace scope
# @param $1 the name of the variable
# @returns the value of the variable
#
define anrem-ns-local-get =
$($(call anrem-ns-local, $1))
endef

#
# Create a proxy symbol to access a namespace local variable in
# the current scope
# @param $1 local symbol name
#
define anrem-ns-local-def-proxy =
$(call anrem-proxy, $(strip $(ANREM_LOCAL_NS_TAG_GET))$(strip $1), anrem-ns-local-get, $1)
endef

## shorthand method for anrem-ns-local-set and get

#
# The idea is to define a block of local variables as
# The tags (the thingy inside the $(..) stuff) is configurable from mk/tags.mk 
#
#
# $(!&) # start of local definition block
# $(&)myvar_1 := something
# $(&)myvar_2 := other_stuff
# $(&!) # end of local definition block, from now on can use $(&myvar_1)
#

#
# Shorthand version for anrem-ns-local-set,
# define the start of a local variable block
#
define $(ANREM_LOCAL_NS_TAG_BLK_START) =
$(eval anrem-ns-local-snapshot := $(sort $(.VARIABLES) anrem-ns-local-snapshot))
endef

#
# short version of anrem-ns-local-set, in practice
# this is used to the the local prefix for a variable like
#
# @returns the variable local prefix
#
define $(ANREM_LOCAL_NS_TAG_SET) =
$(strip $(strip $(call anrem-ns-local-get-prefix))_)
endef

#
# Shorthand version for anrem-ns-local-set,
# define the end of a local variable block
#
define $(ANREM_LOCAL_NS_TAG_BLK_END) =
$(strip \
	$(foreach anrem-ns-local-blk-end,$(.VARIABLES),\
		$(if $(filter $(anrem-ns-local-blk-end),$(anrem-ns-local-snapshot)),
			$(NOP),\
			$(call anrem-ns-local-def-proxy, \
				$(subst $(call anrem-ns-local-get-prefix)_,,$(anrem-ns-local-blk-end))\
			)\
		)\
	)\
)
endef
