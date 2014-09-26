#
# declare here namespace in ./src_1/namespace_1
#

TEST_SCOPE_PATH_BASE := $(call anrem-current-path)

# use custom name to avoid conflict among ./src_2/confilcts/namespace_1 and ./src_1/namespace_1
$(call anrem-ns-register, ./src_1/namespace_1, src_1_ns_1)

# register a namespace with its default name
$(call anrem-ns-register, ./src_1/namespace_2)
