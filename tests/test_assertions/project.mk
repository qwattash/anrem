#
# This is used to test the test assertions
# and generic test functions
#
#
# This is also run in recursive make for convenience of isolation
# without help from anrem

###########
# Warning
# No anrem feature can be used other than the tested ones,
# so no local vars and shit
#

# load helpers if not already loaded
$(call anrem-test-load-helpers)

# set test log location
$(call anrem-test-set-log, test.log)

## helpers for parsing the log file

define rst =
$(shell echo -e "" > test.log)
endef

define read =
$(shell cat test.log)
endef

define find =
$(shell cat test.log | grep "$(strip $1)")
endef

define grep =
$(strip \
	$(shell echo -e "$(strip $2)" | grep "$(strip $1)")\
)
endef

# test the assertions

# NOTE
# anrem pass, fail, warn and msg are assumed to be
# working.
#
$(info Outputting messages for display testing)
$(info ------------------------)
$(call anrem-pass, This should pass)
$(info ------------------------)
$(call anrem-fail, This should fail)
$(info ------------------------)
$(call anrem-warn, This is a warning)
$(info ------------------------)

#
# This checks that the informations are present in the output
# not the formatting of the informations, e.g. the message prefix or
# description, the label for the expected value...

################ Assert Strict Eq
$(call anrem-warn, Test AssertStrictEqual)

$(rst)
$(call anrem-assert-seq, My Message,astring,astring)
tmp := $(read)

$(if $(call grep, PASS, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-seq, This should fail,astring, astring)
tmp := $(read)

$(if $(call grep, FAIL, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-seq, This should fail,astring,other)
tmp := $(read)

$(if $(call grep, FAIL, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-seq, This should fail,astring,)
tmp := $(read)

$(if $(call grep, FAIL, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-seq, This should fail,,astring)
tmp := $(read)

$(if $(call grep, FAIL, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-seq, Testing null,,)
tmp := $(read)

$(if $(call grep, PASS, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

################ Assert Eq
$(call anrem-warn, Test AssertEqual)

$(rst)
$(call anrem-assert-eq, Basic pass case,astring,astring)
tmp := $(read)

$(if $(call grep, PASS, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-eq, Test strip, astring  ,astring)
tmp := $(read)

$(if $(call grep, PASS, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-eq, This should fail,,astring)
tmp := $(read)

$(if $(call grep, FAIL, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-eq, This should fail, astring  ,  other )
tmp := $(read)

$(if $(call grep, FAIL, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-eq, Test strip blank,  ,)
tmp := $(read)

$(if $(call grep, PASS, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

################ Assert Not Eq
$(call anrem-warn, Test AssertNotEqual)

$(rst)
$(call anrem-assert-neq, Test strip, astring  , other)
tmp := $(read)

$(if $(call grep, PASS, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-neq, This should fail, astring  , astring)
tmp := $(read)

$(if $(call grep, FAIL, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-neq, This should fail,,)
tmp := $(read)

$(if $(call grep, FAIL, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

################ Assert List Eq
$(call anrem-warn, Test AssertListEqual)

list_1 := a b c d
list_2 := a b
list_3 := a c d b
list_4 := foo bar baz
list_5 := $(NULL)

$(rst)
$(call anrem-assert-eq-list, Test list,$(list_1),$(list_1))
tmp := $(read)

$(if $(call grep, PASS, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-eq-list, This should fail,$(list_1),$(list_2))
tmp := $(read)

$(if $(call grep, FAIL, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-eq-list, This should fail,$(list_1),$(list_3))
tmp := $(read)

$(if $(call grep, FAIL, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-eq-list, This should fail,$(list_1),$(list_4))
tmp := $(read)

$(if $(call grep, FAIL, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-eq-list, Null list,$(list_5),$(list_5))
tmp := $(read)

$(if $(call grep, PASS, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-eq-list, This should fail,$(list_1),$(list_5))
tmp := $(read)

$(if $(call grep, FAIL, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

################ Assert List Same
$(call anrem-warn, Test AssertSameList)


$(rst)
$(call anrem-assert-same-list, Equal list,$(list_1),$(list_1))
tmp := $(read)

$(if $(call grep, PASS, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-same-list, Same list,$(list_1),$(list_3))
tmp := $(read)

$(if $(call grep, PASS, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-same-list, This should fail,$(list_2),$(list_1))
tmp := $(read)

$(if $(call grep, FAIL, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-same-list, Empty list,,)
tmp := $(read)

$(if $(call grep, PASS, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

################ Assert List In
$(call anrem-warn, Test AssertInList)

$(rst)
$(call anrem-assert-list-in, Empty list,,)
tmp := $(read)

$(if $(call grep, PASS, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-list-in, Item in list,a,$(list_1))
tmp := $(read)

$(if $(call grep, PASS, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-list-in, This should fail,foo,$(list_1))
tmp := $(read)

$(if $(call grep, FAIL, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

################ Assert List Not In
$(call anrem-warn, Test AssertNotInList)

########################

$(rst)
$(call anrem-assert-list-not-in, Basic test, foo, $(list_1))
tmp := $(read)

$(if $(call grep, PASS, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-list-not-in, This should fail, a, $(list_1))
tmp := $(read)

$(if $(call grep, FAIL, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-list-not-in, Empty list and element,,)
tmp := $(read)

$(if $(call grep, PASS, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-list-not-in, Empty element,,$(list_1))
tmp := $(read)

$(if $(call grep, PASS, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

################ Assert File Exists
$(call anrem-warn, Test AssertFileExist)

$(rst)
$(call anrem-assert-exists, Existing file,project.mk)
tmp := $(read)

$(if $(call grep, PASS, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-exists, This should fail,unexisting)
tmp := $(read)

$(if $(call grep, FAIL, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-exists, This should fail,)
tmp := $(read)

$(if $(call grep, FAIL, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

################ Assert File Not Exists
$(call anrem-warn, Test AssertFileNotExist)


$(rst)
$(call anrem-assert-exists, This should fail,)
tmp := $(read)

$(if $(call grep, FAIL, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-not-exists, This should fail,project.mk)
tmp := $(read)

$(if $(call grep, FAIL, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-not-exists, Unexisting file, unexisting)
tmp := $(read)

$(if $(call grep, PASS, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)

########################

$(rst)
$(call anrem-assert-not-exists, Null file,)
tmp := $(read)

$(if $(call grep, PASS, $(tmp)), \
	$(call anrem-pass, Assert strict eq: pass test case <pass status>), \
	$(call anrem-fail, Assert strict eq: pass test case <pass status>)\
)
