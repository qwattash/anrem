#
# Module mk for ./src_2/conflicts/namespace_1
#

# check current path
$(call anrem-assert-eq, Path for ./src_2/conflicts/namespace_1, $(call anrem-current-path), ./src_2/conflicts/namespace_1)

# check that the scope file was correctly seeing the path
$(call anrem-assert-eq, Path for ./src_2/conflicts/namespace_1 in scope file, $(TEST_SCOPE_PATH_CONFLICT), ./src_2/conflicts/namespace_1)
