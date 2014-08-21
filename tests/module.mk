#
# This file defines the test functions to be run
# to make sure that ANREM has worked as expected
# and all module have been built correctly.
#
TEST_BASE := $(call anrem-current-path)

# load anrem test helpers
$(call anrem-test-load-helpers)

# enable test logging
$(call anrem-test-set-log, $(shell pwd)/test.log)

## register the main test target
#$(call anrem-test):
#	$(call anrem-msg, Beginning self-test in $(TEST_BASE))
##	Testing is done with recursive make, this is ok because each test fixture is
##	designed to be self contained in a separate anrem project
#	for test_project in $$(ls $(TEST_BASE) | grep "test_.*"); do cd $(TEST_BASE)/$$test_project && make && cd ..; done
#	$$(call anrem-msg, End of self-test)
