#
#
# Special targets for the system, including default make targets
# that should not be defined in the project.mk
#

.PHONY: $(ANREM_BUILD_CLEAN)

all: $(ANREM_BUILD_TARGETS)

clean: $(ANREM_BUILD_CLEAN)

test: $(ANREM_TEST_TARGETS)
