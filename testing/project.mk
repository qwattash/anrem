########################
# WARNING 
# The following are testing helpers used in the testing part
# these should be removed in your project
########################
#
# Basic output helpers
#
anrem-pass = $(info $(shell echo -e "\e[32m[+]$1 -> OK\e[0m"))

anrem-fail = $(info $(shell echo -e "\e[31m[-]$1 -> FAIL\e[0m"))

anrem-warn = $(info $(shell echo -e "\e[33m[.]$1\e[0m"))

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

# Include manually the test targets and add them manually to a special target list
# this make sure that the targets will be run regardless of the correctness of the
# anrem system functions
ANREM_SELF_TEST_TGTS := targets inclusion pathhandling util modvars
ANREM_SELF_TEST := $(addprefix tests/, $(addsuffix .test,$(ANREM_SELF_TEST_TGTS)))

# variable used for module inclusion check
__module_inclusion_ack := $(NULL)
__module_current_path := $(NULL)

$(foreach __item__,$(ANREM_SELF_TEST),\
	$(eval -include $(__item__))\
)

# define special target
.PHONY: selftest dummy_star

dummy_start:
	$(call anrem-warn, Selftest started...)

selftest: dummy_start $(addprefix test_,$(ANREM_SELF_TEST_TGTS))
	$(call anrem-warn, Selftest finished.)

# override predefined test defined in anrem main makefile
predefined: selftest
