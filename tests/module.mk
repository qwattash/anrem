#
# This file defines the test functions to be run
# to make sure that ANREM has worked as expected
# and all module have been built correctly.
#
TEST_BASE := $(call anrem-current-path)

# load anrem test helpers
$(call anrem-test-load-helpers)

# enable test logging
$(call anrem-test-set-log, test.log)

$(call anrem-warn, something)

## register the main test target
$(call anrem-test): test-module-inclusion test-targets

$(call anrem-test-clean):
	rm test.log


# the assertions need special care when tested since some tests are meant to fail
# the test must be invoked manually
$(call anrem-target, test-assertions):
##	Testing is done with recursive make, this is ok because each test fixture is
##	designed to be self contained in a separate anrem project
	$(call anrem-msg, Test $(TEST_BASE)/test_assertions)
	@make test -C $(TEST_BASE)/test_assertions
	$(call anrem-msg, End of $(TEST_BASE)/test_assertions)

$(call anrem-target, test-module-inclusion):
##	Testing is done with recursive make, this is ok because each test fixture is
##	designed to be self contained in a separate anrem project
	$(call anrem-msg, Test $(TEST_BASE)/test_module_inclusion)
	@make test -C $(TEST_BASE)/test_module_inclusion
	$(call anrem-msg, End of $(TEST_BASE)/test_module_inclusion)

$(call anrem-target, test-targets):
##	Testing is done with recursive make, this is ok because each test fixture is
##	designed to be self contained in a separate anrem project
	$(call anrem-msg, Test $(TEST_BASE)/test_targets)
	@make test_main -C $(TEST_BASE)/test_targets
	$(call anrem-msg, End of $(TEST_BASE)/test_targets)
