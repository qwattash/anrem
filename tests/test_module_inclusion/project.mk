#
# This test is meant to be run in a separate make environment
#
#

#################################
# Fixture: test module inclusion
# 
# Units: module inclusion, namespace inclusion, 
# module variable declaration, module variable access
#

# load helpers in the recursive make environment
$(call anrem-test-load-helpers)

# enable test logging
$(call anrem-test-set-log, test.log)

# inital module path should be set to current directory (./) since the project.mk is included
# as the first mk of a namespace
$(call anrem-assert-eq, Initial module path, $(call anrem-current-path), .)

# check that the scope file was correctly seeing the path
$(call anrem-assert-eq, Path for . in scope file, $(TEST_SCOPE_PATH_BASE), .)

#
# Check that all module and namespace variables are set
# and have the correct path in them
#

$(call anrem-assert-eq, |test_module_inclusion, ., $(|test_module_inclusion))
$(call anrem-assert-eq, test_module_inclusion|module_1, ./src_1/module_1, $(test_module_inclusion|module_1))
$(call anrem-assert-eq, test_module_inclusion|module_1|module_1-1, ./src_1/module_1/module_1-1, $(test_module_inclusion|module_1|module_1-1))
$(call anrem-assert-eq, test_module_inclusion|module_1|module_1-2, ./src_1/module_1/module_1-2, $(test_module_inclusion|module_1|module_1-2))
$(call anrem-assert-eq, test_module_inclusion|module_2, ./src_1/module_2, $(test_module_inclusion|module_2))
## conflicting module in main namespace renamed
$(call anrem-assert-eq, test_module_inclusion|conflict_module_1, ./src_2/conflicts/module_1, $(test_module_inclusion|conflict_module_1))


# renaming of a custom namespace
$(call anrem-assert-eq, |src_1_ns_1, ./src_1/namespace_1, $(|src_1_ns_1))
$(call anrem-assert-eq, src_1_ns_1|ns_1_module_1, ./src_1/namespace_1/ns_1_module_1, $(src_1_ns_1|ns_1_module_1))
# this has been marked to be ingored
$(call anrem-assert-eq, Ignored src_1_ns_1|ns_1_module_2,, $(src_1_ns_1|ns_1_module_2))

## test renaming of a project namespace
$(call anrem-assert-eq, |conflict_ns_1, ./src_2/conflicts/namespace_1, $(|conflict_ns_1))
$(call anrem-assert-eq, conflict_ns_1|conflict_ns_1_module_1, ./src_2/conflicts/namespace_1/ns_1_module_1, $(conflict_ns_1|conflict_ns_1_module_1))

## custom namespace without renaming
$(call anrem-assert-eq, |namespace_2, ./src_1/namespace_2, $(|namespace_2))
$(call anrem-assert-eq, namespace_2|ns_2_module_1, ./src_1/namespace_2/ns_2_module_1, $(namespace_2|ns_2_module_1))

## project namespace without renaming
$(call anrem-assert-eq, |ns_1_namespace_1, ./src_1/namespace_1/ns_1_namespace_1, $(|ns_1_namespace_1))
$(call anrem-assert-eq, ns_1_namespace_1|ns_1_ns_1_module_1, ./src_1/namespace_1/ns_1_namespace_1/ns_1_ns_1_module_1, $(ns_1_namespace_1|ns_1_ns_1_module_1))

## check that no other variables have been defined

expected-module-variables := |test_module_inclusion test_module_inclusion|module_1 test_module_inclusion|module_2 test_module_inclusion|conflict_module_1\
 test_module_inclusion|module_1|module_1-1 test_module_inclusion|module_1|module_1-2
expected-module-variables += |src_1_ns_1 src_1_ns_1|ns_1_module_1
expected-module-variables += |conflict_ns_1 conflict_ns_1|conflict_ns_1_module_1
expected-module-variables += |namespace_2 namespace_2|ns_2_module_1
expected-module-variables += |ns_1_namespace_1 ns_1_namespace_1|ns_1_ns_1_module_1
# namespace include shortcuts
expected-module-variables += I|src_1_ns_1 I|conflict_ns_1 I|namespace_2 I|ns_1_namespace_1 I|test_module_inclusion

module-variables := $(NULL)

# exclude form list dictionary items (variables containing square brakets)
$(foreach v,$(.VARIABLES),\
	$(if $(findstring |,$(v)),\
		$(if $(findstring [,$(v)),$(NOP),\
			$(eval module-variables += $(v))\
		),\
		$(NOP)\
	)\
)

# check that no other variables have been defined
$(call anrem-assert-same-list, No other variables defined, $(module-variables), $(expected-module-variables))

## check that the namespace dictionaries hold the correct paths
$(call anrem-assert-same-list, namespace1 dict keys, $(call anrem-dict-keys, test_module_inclusion), module_1 module_2 module_1|module_1-1 module_1|module_1-2 conflict_module_1)
$(call anrem-assert-same-list, namespace1 dict items, $(call anrem-dict-items, test_module_inclusion),./src_1/module_1 ./src_1/module_1/module_1-2 ./src_1/module_2 \
./src_1/module_1/module_1-1 ./src_2/conflicts/module_1)

$(call anrem-assert-same-list, namespace1 dict keys, $(call anrem-dict-keys, src_1_ns_1), ns_1_module_1)
$(call anrem-assert-same-list, namespace1 dict items, $(call anrem-dict-items, src_1_ns_1), ./src_1/namespace_1/ns_1_module_1)

$(call anrem-assert-same-list, namespace1 dict keys, $(call anrem-dict-keys, conflict_ns_1), conflict_ns_1_module_1)
$(call anrem-assert-same-list, namespace1 dict items, $(call anrem-dict-items, conflict_ns_1), ./src_2/conflicts/namespace_1/ns_1_module_1)

$(call anrem-assert-same-list, namespace1 dict keys, $(call anrem-dict-keys, namespace_2), ns_2_module_1)
$(call anrem-assert-same-list, namespace1 dict items, $(call anrem-dict-items, namespace_2), ./src_1/namespace_2/ns_2_module_1)

$(call anrem-assert-same-list, namespace1 dict keys, $(call anrem-dict-keys, ns_1_namespace_1), ns_1_ns_1_module_1)
$(call anrem-assert-same-list, namespace1 dict items, $(call anrem-dict-items, ns_1_namespace_1), ./src_1/namespace_1/ns_1_namespace_1/ns_1_ns_1_module_1)
