#
# Module mk for ./src_1/module_1
#

# check current path
$(call anrem-assert-eq, Path for ./src_1/module_1, $(call anrem-current-path), ./src_1/module_1)
