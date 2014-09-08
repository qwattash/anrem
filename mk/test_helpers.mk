########################
# 
# The following are testing helpers used in the testing part
# this file is loaded upon request by anrem-test-load-helpers
########################

# import terminal colors
-include $(ANREM_COMPONENTS)/termcolors.mk

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
		| tee -a $(ANREM_TEST_LOG_FILE),\
		$(NULL),
	)
endef

#
# Short version for anrem-test-log
#
define $(ANREM_TEST_TAG_LOG) =
$(strip $(call anrem-test-log))
endef

#####################
# Basic output helpers
# to be used as shell commands
#

define anrem-log-prefix =
$(shell echo -e "[$$(date '+%T-%x')]")
endef

##### coloring functions

define anrem-make-green =
$(shell echo -e "$(anrem-term-green)$(strip $1)$(anrem-term-end)")
endef

define anrem-make-red = 
$(shell echo -e "$(anrem-term-red)$(strip $1)$(anrem-term-end)")
endef

define anrem-make-yellow =
$(shell echo -e "$(anrem-term-yellow)$(strip $1)$(anrem-term-end)")
endef

###### output functions

#
# output function that also log the output
# @param $1 the string to print
# @param $2 the coloring function
#
define anrem-test-echo =
$(strip \
	$(shell echo -e "$(call anrem-log-prefix)$(strip $1)" >> $(ANREM_TEST_LOG_FILE))\
	$(info $(call $2, $(strip $1)))\
)
endef

###### assertion output functions

define anrem-pass = 
$(call anrem-test-echo, [+] $(strip $1) -> PASS, anrem-make-green)
endef

define anrem-fail = 
$(call anrem-test-echo, [-] $(strip $1) -> FAIL, anrem-make-red)
endef

define anrem-warn = 
$(call anrem-test-echo, [.] $(strip $1), anrem-make-yellow)
endef

# this is a variant of anrem warn designed to be called inside test rules
# @TODO is this deprecated??
#
define anrem-msg = 
$(strip @echo -e "$(anrem-term-yellow)[.] $(strip $1) $(anrem-term-end)" && \
echo "$(call anrem-log-prefix)[.] $(strip $1)" >> $(ANREM_TEST_LOG_FILE))
endef

#
# format the print of a list
# @param $1 the list to be printed
# @param $2 coloring function
#
define anrem-list-fancy-print =
$(foreach anrem-list-fancy-print-item, $(subst $(SPACE),$(COMMA)$(SPACE),$(strip $1)),\
	$(call anrem-test-echo, $(anrem-list-fancy-print-item), $2)\
)
endef

########################
# Assertions
#

#
# A more verbose error function for failures
# @param $1 the test message string
# @param $2 the assertion error message
# @param $3 the expected value
# @param $4 the value found instead
#
define anrem-test-fail =
$(call anrem-fail, $1: $2; Expected $3 but found $4)
endef

#
# A better formatted failure function for lists
# @param $1 the test message string
# @param $2 the assertion error message
# @param $3 the expected value
# @param $4 the value found instead
#
define anrem-test-list-fail =
$(call anrem-fail, $1: $2)\
$(call anrem-test-echo, Expected: [, anrem-make-red)\
$(call anrem-list-fancy-print, $3, anrem-make-red)\
$(call anrem-test-echo, ], anrem-make-red)\
$(call anrem-test-echo, Found: [, anrem-make-red)\
$(call anrem-list-fancy-print, $4, anrem-make-red)\
$(call anrem-test-echo, ], anrem-make-red)
endef

#
# Prints the diff of two lists, useful for error
# reporting
# @param $1 expected list
# @param $2 found list
# @param $3 coloring function
#
define anrem-test-list-diff =
$(call anrem-test-echo, Extra items: [, $3)\
$(call anrem-list-fancy-print, $(filter-out $1, $2), $3)\
$(call anrem-test-echo, ], $3)\
$(call anrem-test-echo,  Missing items: [, $3)\
$(call anrem-list-fancy-print, $(filter-out $2, $1), $3)\
$(call anrem-test-echo, ], $3)
endef

#
# notice that shell comparisons are used, this might be bad but
# the testing code is limited to the anrem tests for now
#
# all assertion functions have the following signature
# @param $1 assertion message
# @param $2 assertion param #1 (value found)
# @param $3 assertion param #2 (if needed) (value expected)
#
# >>> WARNING <<<
# strict equal assertion
# Pay attention to how you call these functions!
# $(call anrem-assert-eq, message, 10, 10) //pass
# $(call anrem-assert-eq, message, 10,10) //fail
# spaces are not stripped because it may trigger false negatives, however
# is up to the developer not to trigger false positives!
#
define anrem-assert-seq = 
$(strip \
	$(if $(shell if [ "$2" = "$3" ]; then echo "1"; fi),\
		$(call anrem-pass, $1),\
		$(call anrem-test-fail, $1, Not strictly equal,'$2','$3')\
	)\
)
endef

#
# Same as above but strip whitespaces before evaluating
# the input.
# This may be safer than anrem-asser-eq
#
define anrem-assert-eq = 
$(strip \
	$(if $(shell if [ "$(strip $2)" = "$(strip $3)" ]; then echo "1"; fi),\
		$(call anrem-pass, $1),\
		$(call anrem-test-fail, $1, Not equal,'$2','$3')\
	)\
)
endef

define anrem-assert-neq = 
$(strip \
	$(if $(shell if [ "$(strip $2)" != "$(strip $3)" ]; then echo "1"; fi),\
		$(call anrem-pass, $1),\
		$(call anrem-test-fail, $1, Equal,not '$2','$3')\
	)\
)
endef

#
# check that given element is not in the list
# @param $2 element
# @param $3 list
#
define anrem-assert-list-not-in =
$(strip \
	$(if $(filter $2,$3),\
		$(call anrem-test-fail, $1, Element is in list,'[$(filter-out $2, $3)]','[$3]'),\
		$(call anrem-pass, $1)\
	)\
)
endef

#
# check that given element is in the list
#
# In the corner case that both $2 and $3 are null the test passes
#
# @param $2 element
# @param $3 list
#
define anrem-assert-list-in =
$(strip \
	$(if $(strip $2$3),
		$(if $(filter $2,$3),\
			$(call anrem-pass, $1),\
			$(call anrem-test-fail, $1, Element is in list,'[$(strip $2 $3)]','[$3]')
		),\
		$(call anrem-pass, $1)\
	)\
)
endef

# this checks the ordering too
define anrem-assert-eq-list =
$(strip \
	$(call anrem-assert-eq,$1, $(strip $2), $(strip $3))\
)
endef

# this does not check the ordering
# check that all elements in list 1 are present the same number of
# times in list 2, then filter out list 2 with list 1 and detect
# any left additional items
define anrem-assert-same-list =
$(strip \
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
		$(call anrem-test-list-fail, $1, List has not the same elements, $3, $2)\
		$(call anrem-test-list-diff, $3, $2, anrem-make-red)\
		,\
		$(call anrem-pass, $1)\
	)\
)
endef

# file exists
define anrem-assert-exists = 
$(strip \
	$(if $(shell if [ -e "$(strip $2)" ]; then echo "1"; fi),\
		$(call anrem-pass, $1),\
		$(call anrem-test-fail, $1, File does not exist,'$2','No file')\
	)\
)
endef

# file does not exist
define anrem-assert-not-exists = 
$(strip \
	$(if $(shell if [ -e "$(strip $2)" ]; then echo "1"; fi),\
		$(call anrem-test-fail, $1, File exist,'No file','$2'),\
		$(call anrem-pass, $1)\
	)\
)
endef
