#
# This file defines the test functions to be run
# to make sure that ANREM has worked as expected
# and all module have been built correctly.
# In future a more test-oriented approach may be taken
# however for now it sufficient to see if the tests compiled
#
CURRENT := $(call anrem-current-path)

$(call anrem-test, test_$(CURRENT)):
	@echo "Testing ANREM outputs"
	$(MOD_mod1)/hello
	$(MOD_name)/hello
	$(MOD_main)/../build/hello

$(info Sample module.mk says $(call anrem-ns-local-get, my_local_var))
