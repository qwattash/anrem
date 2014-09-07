#
# Module mk for ./src_2/namespace_1/conflicts/module_1
#

# check current path
$(call anrem-assert-eq, Path for ./src_2/conflicts/module_1, $(call anrem-current-path), ./src_2/conflicts/module_1)
