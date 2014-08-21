###################
#
# Project mk file for a test tree
# This loads test helpers and define a custom predefined target that runs the tests
#
###################

# load test helpers
$(call anrem-test-load-helpers)

### TODO modify this part
#
## Include manually the test targets and add them manually to a special target list
## this make sure that the targets will be run regardless of the correctness of the
## anrem system functions
#ANREM_SELF_TEST_TGTS := targets inclusion pathhandling util modvars
#ANREM_SELF_TEST := $(addprefix tests/, $(addsuffix .test,$(ANREM_SELF_TEST_TGTS)))
#
## variable used for module inclusion check
#__module_inclusion_ack := $(NULL)
#__module_current_path := $(NULL)
#
#$(foreach __item__,$(ANREM_SELF_TEST),\
#	$(eval -include $(__item__))\
#)
#
## define special target
#.PHONY: selftest
#
#dummy_start:
#	$(call anrem-warn, Selftest started...)
#
#selftest: dummy_start $(addprefix test_,$(ANREM_SELF_TEST_TGTS))
#	$(call anrem-warn, Selftest finished.)

# override predefined test defined in anrem main makefile
predefined: test
