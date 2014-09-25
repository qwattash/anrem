###################
#
# Project mk file for a test tree
# This loads test helpers and define a custom predefined target that runs the tests
#
###################

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

# target group subscription
current_path := $(call anrem-current-path)

$(call anrem-target-group-add, test_group_1, __dummy_tgt_1)

$(call anrem-target-group-add, test_group_2, __dummy_tgt_1)
$(call anrem-target-group-add, test_group_2, __dummy_tgt_1)
$(call anrem-target-group-add, test_group_2, __dummy_tgt_2)

# test target group generation
tgt_dep_1 := $(call anrem-target-group-depend, test_group_1)
tgt_dep_2 := $(call anrem-target-group-depend, test_group_2)
tgt_dep_3 := $(call anrem-target-group-depend, test_group_3)

test_main:
# test target group generation
	$(call anrem-assert-eq, Target group bridge target 1, $(tgt_dep_1), __anrem_target_group_test_group_1)
	$(call anrem-assert-eq, Target group bridge target 2, $(tgt_dep_2), __anrem_target_group_test_group_2)
# test target group members
	$(call anrem-assert-eq, Target group members 1, $(call anrem-target-group-members, test_group_1), __dummy_tgt_1)
	$(call anrem-assert-same-list, Target group members 2, $(call anrem-target-group-members, test_group_2), __dummy_tgt_1 __dummy_tgt_2)
# test target group modules
	$(call anrem-assert-eq, Target group modules 1, $(call anrem-target-group-modules, test_group_1), $(current_path))
	$(call anrem-assert-eq, Target group modules 2, $(call anrem-target-group-modules, test_group_2), $(current_path))
# test output of building functions
	@make -C . build/hello > build_output.txt
	@$(call anrem-assert-diff-sh, build_output.txt, build_output.sample)
	@./build/hello > artifact_output.txt
	@$(call anrem-assert-diff-sh, artifact_output.txt, artifact_output.sample)
	@make -C . clean > clean_output.txt
	@$(call anrem-assert-diff-sh, clean_output.txt, clean_output.sample)


$(call anrem-test-clean):
	rm -f artifact_output.txt clean_output.txt build_output.txt

