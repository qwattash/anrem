###########
#
# target groups
# Define target group functions that are used to build groups of targets
# that can be used as a single target
# The main difference with normal targets is that the group provides lazy resolution
# of the members of the group, in practice something depending on the group will depend
# on all the targets subscribed in that group, no matter in what order.
#

#
# Helper, resolve internal group name
# representation from the group name
# @param $1: group ID
define anrem-target-group-build-name =
__anrem_target_group_$(strip $1)
endef

#
# subscribe target to group
# @param $1: group ID
# @param $2: target list
define anrem-target-group-add = 
$(strip \
	$(eval anrem-target-group-add-name := $(strip $(call anrem-target-group-build-name, $(call anrem-expand-local, $1))))\
	$(eval \
		$(anrem-target-group-add-name): $(strip $(call anrem-expand-local, $2))\
	)\
	$(eval GROUP_ITEMS[$(anrem-target-group-add-name)] += $(strip $(call anrem-expand-local, $2)))\
	$(eval GROUP_MODULES[$(anrem-target-group-add-name)] += $(strip $(call anrem-current-path)))\
	$(call anrem-list-unique, GROUP_MODULES[$(anrem-target-group-add-name)])\
	$(call anrem-list-unique, GROUP_ITEMS[$(anrem-target-group-add-name)])\
)
endef

#
# get target group reference to be used
# as a dependency from the group
# @param $1: group ID
define anrem-target-group-depend =
$(eval .INTERMEDIATE: $(call anrem-target-group-build-name, $(call anrem-expand-local, $1)))\
$(call anrem-target-group-build-name, $(call anrem-expand-local, $1))
endef

#
# get target group members
# @param $1: group ID
define anrem-target-group-members =
$(call anrem-dict-get, GROUP_ITEMS, $(call anrem-target-group-build-name, $(call anrem-expand-local, $1)))
endef

#
# get modules that have members in the group
# this is useful to group header files and
# build -I flags
# @param $1: group ID
define anrem-target-group-modules =
$(call anrem-dict-get, GROUP_MODULES, $(call anrem-target-group-build-name, $(call anrem-expand-local, $1)))
endef
