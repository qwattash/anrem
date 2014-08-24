##########
#
# local variables
# Here are defined the functions that manage module local variables
# and expansion of the @ tags to the local variable value
#

#
# Expand a local variable beginning by @, if possible
# otherwise return the same text given as input
# such as @mylocalvar
# @param $1 local variable name or normal text
#
define anrem-expand-local = 
$(strip \
	$(if $(filter @%,$(strip $1)),\
		$(call anrem-local-get, $(patsubst @%,%,$(strip $1))),\
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
$(strip $(strip $(call anrem-local-get-suffix))_$1)
endef

#
# Helper for anrem-local, gives the current path
# from both inside a target rule and outside.
define anrem-local-get-suffix =
$(if $(filter $(ANREM_MODULE_END),$(call anrem-current-path)),
	$(path),\
	$(call anrem-current-path)\
)
endef

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
