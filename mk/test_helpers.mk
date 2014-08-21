########################
# 
# The following are testing helpers used in the testing part
# this file is loaded upon request by anrem-test-load-helpers
########################

#####################
# support for logging of test output
#

# log file path
ANREM_TEST_LOG_FILE = $(NULL)

# set the test log file
# @param $1 log file, if null logging is disabled 
#
define anrem-test-set-log =
	$(eval ANREM_TEST_LOG_FILE = $(strip $1))
endef

# this generate the pipe command part that enables logging
# control using anrem for toggling the logging capability
#
# This should be called in test shell commands that should be logged
# anrem test functions such as assertion do logging on their own
#
define anrem-test-log =
	$(if $(ANREM_TEST_LOG_FILE),\
		| tee $(ANREM_TEST_LOG_FILE),\
		$(NULL),
	)
endef

#####################
# Basic output helpers
#
anrem-pass = $(info $(shell echo -e "\e[32m[+]$1 -> OK\e[0m"))

anrem-fail = $(info $(shell echo -e "\e[31m[-]$1 -> FAIL\e[0m"))

anrem-warn = $(info $(shell echo -e "\e[33m[.]$1\e[0m"))

# this is a variant of anrem warn designed to be called inside test rules
anrem-msg = @echo -e "\e[33m[.]$1\e[0m"

#
# Assertions
# notice that shell comparisons are used, this is bad but the scope of
# the testing code is limited and not oriented to production.
#
# all assertion functions have the following signature
# @param $1 assertion message
# @param $2 assertion param #1
# @param $3 assertion param #2 (if needed)
#
# >>> WARNING <<<
# Pay attention to how you call these functions!
# $(call anrem-assert-eq, message, 10, 10) //pass
# $(call anrem-assert-eq, message, 10,10) //fail
# spaces are not stripped because it may trigger false negatives, however
# is up to the developer not to trigger false positives!
#
define anrem-assert-eq = 
$(if $(shell if [ "$2" = "$3" ]; then echo "1"; fi),\
	$(call anrem-pass, $1),\
	$(call anrem-fail, $1)\
)
endef

#
# Same as above but strip whitespaces before evaluating
# the input.
# This may be safer than anrem-asser-eq
#
define anrem-strip-assert-eq = 
$(if $(shell if [ $(strip "$2") = $(strip "$3") ]; then echo "1"; fi),\
	$(call anrem-pass, $1),\
	$(call anrem-fail, $1)\
)
endef

define anrem-assert-neq = 
$(if $(shell if [ "$2" != "$3" ]; then echo "1"; fi),\
	$(call anrem-pass, $1),\
	$(call anrem-fail, $1)\
)
endef

#
# check that given element is not in the list
# @param $2 list
# @param $3 element
#
define anrem-assert-not-in-list =
$(if $(filter $3,$2),\
	$(call anrem-fail, $1),\
	$(call anrem-pass, $1)\
)
endef

# this checks the ordering too
define anrem-assert-eq-list =
$(call anrem-assert-eq,$1, $(strip $2), $(strip $3))
endef

# this does not check the ordering
# check that all elements in list 1 are present the same number of
# times in list 2, then filter out list 2 with list 1 and detect
# any left additional items
define anrem-assert-same-list =
$(eval anrem-assert-same-list-result := $(NULL))\
$(foreach anrem-assert-same-list-item1,$2,\
	$(if $(filter $(anrem-assert-same-list-item1),$3),\
		$(if $(filter $(words $(filter $(anrem-assert-same-list-item1),$3)),\
				$(words $(filter $(anrem-assert-same-list-item1),$2))),\
			$(NULL),\
			$(eval anrem-assert-same-list-result := F)\
		)\
	,\
		$(eval anrem-assert-same-list-result := F)\
	)\
)\
$(if $(filter-out $2,$3),\
	$(eval anrem-assert-same-list-result := F)\
)\
$(if $(anrem-assert-same-list-result),\
	$(call anrem-fail, $1),\
	$(call anrem-pass, $1)\
)
endef

# file exists
define anrem-assert-exists = 
$(if $(shell if [ -e $2 ]; then echo "1"; fi),\
	$(call anrem-pass, $1),\
	$(call anrem-fail, $1)\
)
endef

# file does not exist
define anrem-assert-not-exists = 
$(if $(shell if [ -e $2 ]; then echo "1"; fi),\
	$(call anrem-fail, $1),\
	$(call anrem-pass, $1)\
)
endef
