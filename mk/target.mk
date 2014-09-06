#########
#
# target handling functions
# Here are defined the functions that are used to manage anrem targets
#

#
# declare a target and add given it to the global targets list
# that is executed when make all is run
# @param $1 target
#
define anrem-build =
$(strip \
$(call anrem-target, $(call anrem-expand-local, $1))\
$(call anrem-build-list-add, $(call anrem-expand-local, $1))\
)
endef
#
# declare a clean target and add given target to the clean list
# that is executed whenever make clean is issued
# If the target name is omitted one is automatically generated
# @param $1 target
#
define anrem-clean = 
$(strip \
	$(call anrem-target, $(call anrem-optarg,$(call anrem-expand-local, $1),clean_$(call anrem-current-path)))\
	$(call anrem-clean-list-add, $(call anrem-optarg,$(call anrem-expand-local, $1),clean_$(call anrem-current-path)))\
)
endef

#
# add a target to the test targets list, the list is meant to hold
# targets used to build unit-tests or other testing code
# @param $1 the target to add to the list
#
define anrem-test = 
$(strip \
	$(call anrem-target, $(call anrem-optarg,$(call anrem-expand-local, $1),test_$(call anrem-current-path)))\
	$(call anrem-test-list-add, $(call anrem-optarg,$(call anrem-expand-local, $1),test_$(call anrem-current-path)))\
)
endef

#
# add a target to the test clean target list, this is meant to
# hold targets used to clean the testing environment
# @param $1 the target to add to the list
#
define anrem-test-clean =
$(strip \
	$(call anrem-target, $(call anrem-optarg,$(call anrem-expand-local, $1),test_clean_$(call anrem-current-path)))\
	$(call anrem-test-clean-list-add, $(call anrem-optarg,$(call anrem-expand-local, $1),test_clean_$(call anrem-current-path)))\
)
endef

#
# declare a target in the current module path.
# This does not add the target to any anrem target list.
# A target-local variable "path" is created to hold the path of the module
# inside the target.
# @param $1 target absolute name
#
define anrem-target = 
$(call anrem-expand-local, $1)\
$(call anrem-target-def-var,\
	$(call anrem-expand-local, $1), \
	path,\
	$(strip $(call anrem-current-path))\
)
endef

#
# add given target to the build list 
# @param $1: target name
define anrem-build-list-add = 
$(eval ANREM_BUILD_TARGETS += $(call anrem-expand-local, $1))
endef
#
# add given target to the clean list 
# @param $1: target name
define anrem-clean-list-add =
$(eval ANREM_BUILD_CLEAN += $(call anrem-expand-local, $1))
endef

#
# add given target to the test list 
# @param $1: target name
define anrem-test-list-add =
$(eval ANREM_TEST_TARGETS += $(call anrem-expand-local, $1))
endef

#
# add given target to the test clean list 
# @param $1: target name
define anrem-test-clean-list-add =
$(eval ANREM_TEST_CLEAN_TARGETS += $(call anrem-expand-local, $1))
endef

############################################# target local variables

#
# define a target-local symbol for a given target and symbol name
# this generates something like:
# <target>: <symbol> := <value>
# @param $1: target for which the symbol is defined
# @param $2: symbol to be defined
# @param $3: value of the symbol
#
anrem-target-def-var = $(eval $(call anrem-expand-local, $1): $(call anrem-expand-local, $2) := $(call anrem-expand-local, $3))
