##
#
# include functions from the library
#

include $(ANREM_COMPONENTS)/tags.mk
include $(ANREM_COMPONENTS)/util.mk
include $(ANREM_COMPONENTS)/modules.mk
include $(ANREM_COMPONENTS)/local.mk
include $(ANREM_COMPONENTS)/target.mk
include $(ANREM_COMPONENTS)/autodeps.mk
include $(ANREM_COMPONENTS)/target-group.mk

############################################## testing

# load test helpers module when requested
define anrem-test-load-helpers =
	$(eval include $(ANREM_COMPONENTS)/test_helpers.mk)
endef
