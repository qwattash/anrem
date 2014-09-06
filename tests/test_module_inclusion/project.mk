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

#$(call anrem-assert-eq, Initial module path, $(ANREM_CURRENT_MODULE), $(NULL))
