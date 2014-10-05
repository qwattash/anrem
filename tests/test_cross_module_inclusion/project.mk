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

ns1_modules = ./src ./src/module_1
ns1_modules_with_flags = -I./src -I./src/module_1

ns2_modules = ./src/namespace_1
ns2_modules_with_flags = -I./src/namespace_1

test_main:
# tests for namespace 1
	$(call anrem-assert-same-list, Namespace base include depends, $(call anrem-ns-get-include-modules, test_cross_module_inclusion), $(ns1_modules))
	$(call anrem-assert-same-list, Namespace base include depends, $(I|test_cross_module_inclusion), $(ns1_modules))
	$(call anrem-assert-same-list, Namespace base include depends with flags, $(call anrem-ns-get-include-modules, test_cross_module_inclusion, -I), $(ns1_modules_with_flags))
# tests for namespace 2
	$(call anrem-assert-same-list, Namespace 1 include depends, $(call anrem-ns-get-include-modules, x_mod_inc_ns1), $(ns2_modules))
	$(call anrem-assert-same-list, Namespace 1 include depends, $(I|x_mod_inc_ns1), $(ns2_modules))
	$(call anrem-assert-same-list, Namespace 1 include depends with flags, $(call anrem-ns-get-include-modules, x_mod_inc_ns1, -I), $(ns2_modules_with_flags))
