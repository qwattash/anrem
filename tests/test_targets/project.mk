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

__build_targets := ./mod1/hello_build ./mod2/hello_build
__clean_targets := ./mod1_hello_clean clean_./mod2
__test_targets := ./mod1/hello_test test_./mod2
__test_clean_targets := ./mod1_hello_test_clean test_clean_./mod2

define reset =
$(eval ANREM_BUILD_TARGETS := $(NULL))\
$(eval ANREM_BUILD_CLEAN := $(NULL))\
$(eval ANREM_TEST_TARGETS := $(NULL))\
$(eval ANREM_TEST_CLEAN_TARGETS := $(NULL))
endef

test_main:
# check consistency of targets created in the example tree
	$(call anrem-assert-same-list, Checking anrem build list, $(ANREM_BUILD_TARGETS), $(__build_targets))
	$(call anrem-assert-same-list, Checking anrem clean list, $(ANREM_BUILD_CLEAN), $(__clean_targets))
	$(call anrem-assert-same-list, Checking anrem test list, $(ANREM_TEST_TARGETS), $(__test_targets))
	$(call anrem-assert-same-list, Checking anrem test clean list, $(ANREM_TEST_CLEAN_TARGETS), $(__test_clean_targets))
# check that target functions work properly
# anrem-target
	$(call reset)
	$(call anrem-assert-eq, Generation of target name, $(call anrem-target, dummy_a), dummy_a)
	$(call anrem-assert-same-list, Tesiting anrem-target, $(ANREM_BUILD_TARGETS), $(NULL))
# anrem-build
	$(call reset)
	$(call anrem-assert-eq, Generation of build target name, $(call anrem-build, dummy_b), dummy_b)
	@echo $(call anrem-build, dummy_c dummy_d) > /dev/null
	$(call anrem-assert-same-list, Registration in the build list, $(ANREM_BUILD_TARGETS), dummy_b dummy_c dummy_d)
# anrem-clean
	$(call reset)
	$(eval ANREM_CURRENT_MODULE := dummy_current__)
	$(call anrem-assert-eq, Generation of clean target automatic name, $(call anrem-clean), clean_dummy_current__)
	$(call anrem-assert-same-list, Registration in the clean list, $(ANREM_BUILD_CLEAN), clean_dummy_current__)
	$(call anrem-assert-eq, Generation of clean target custom name, $(call anrem-clean, custom_clean), custom_clean)
	$(call anrem-assert-same-list, Registration in the clean list, $(ANREM_BUILD_CLEAN), custom_clean clean_dummy_current__)
# anrem-test
	$(call reset)
	$(call anrem-assert-eq, Generation of test target automatic name, $(call anrem-test), test_dummy_current__)
	$(call anrem-assert-same-list, Registration in the test list, $(ANREM_TEST_TARGETS), test_dummy_current__)
	$(call anrem-assert-eq, Generation of test target custom name, $(call anrem-test, custom_test), custom_test)
	$(call anrem-assert-same-list, Registration in the test list, $(ANREM_TEST_TARGETS), custom_test test_dummy_current__)
# anrem-test-clean
	$(call reset)
	$(call anrem-assert-eq, Generation of test target automatic name, $(call anrem-test-clean), test_clean_dummy_current__)
	$(call anrem-assert-same-list, Registration in the test clean list, $(ANREM_TEST_CLEAN_TARGETS), test_clean_dummy_current__)
	$(call anrem-assert-eq, Generation of test target custom name, $(call anrem-test-clean, custom_test), custom_test)
	$(call anrem-assert-same-list, Registration in the test clean list, $(ANREM_TEST_CLEAN_TARGETS), custom_test test_clean_dummy_current__)
# test output of building functions
	@make -C . > build_output.txt
	@$(call anrem-assert-diff-sh, Build target output, build_output.txt, build_output.sample)
	@make clean -C . > clean_output.txt
	@$(call anrem-assert-diff-sh, Clean target output, clean_output.txt, clean_output.sample)
	@make test -C . > test_output.txt
	@$(call anrem-assert-diff-sh, Test target output, test_output.txt, test_output.sample)
	@make testclean -C . > test_clean_output.txt
	@$(call anrem-assert-diff-sh, Test clean target output, test_clean_output.txt, test_clean_output.sample)


