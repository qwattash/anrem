###################
#
# mk file for a test tree
# This file defines the make strategy for a subproject, in this case a test subproject
# In practice it tells anrem if the subproject tree should be traversed 
#
###################

## register the main test target for the nested module
$(call anrem-test):
       $(call anrem-msg, Beginning self-test in $(TEST_BASE))
#      Testing is done with recursive make, this is ok because each test fixture is
#      designed to be self contained in a separate anrem project
       for test_project in $$(ls $(TEST_BASE) | grep "test_.*"); do cd $(TEST_BASE)/$$test_project && make && cd ..; done
       $$(call anrem-msg, End of self-test)
