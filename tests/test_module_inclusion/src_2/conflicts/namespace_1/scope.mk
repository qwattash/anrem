#
# Rename the current namespace, which is a project generated namespace
# This also tests the scope file evaluation since it must be included
#

TEST_SCOPE_PATH_CONFLICT := $(call anrem-current-path)

$(call anrem-ns-register, ./src_2/conflicts/namespace_1, conflict_ns_1)
