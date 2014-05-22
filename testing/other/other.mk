#
# Test mk module
#
#

__module_inclusion_ack += other
__module_current_path += $(call anrem-current-path)

$(call anrem-build, other/build):
	@echo "TODO"

$(call anrem-clean, non_default_clean):
	@echo "TODO"

$(call anrem-test, non_default_test):
	@echo "TODO"

$(call anrem-target, special_test_target):
# this is called as dependency of a test so that the presence and correctness 
#of the $(path) variable is checked
	$(call anrem-assert-eq, Checking local path variable, $(path), other)
