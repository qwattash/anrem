###################
#
# Project mk file for a test tree
# This loads test helpers and define a custom predefined target that runs the tests
#
###################

#################################
# Fixture: test dictionaries
#

# load helpers in the recursive make environment
$(call anrem-test-load-helpers)

# enable test logging
$(call anrem-test-set-log, test.log)

# define a dictionary
mydict[key1] = content1
mydict[key2] = content2

myotherdict[key3] = content3
myotherdict[key4] = content3

mydict[key1] = whatever

test_main:
#	here do the output, functions have already been called during evalutation of the mk file
	$(call anrem-assert-same-list, anrem-dict-keys, key1 key2, $(call anrem-dict-keys, mydict))
	$(call anrem-assert-same-list, anrem-dict-items, whatever content2, $(call anrem-dict-items, mydict))
	$(call anrem-assert-same-list, anrem-dict-keys, key3 key4, $(call anrem-dict-keys, myotherdict))
	$(call anrem-assert-same-list, anrem-dict-items, content3 content3, $(call anrem-dict-items, myotherdict))
	$(call anrem-assert-eq, anrem-dict-has-key, $(TRUE), $(call anrem-dict-has-key, mydict, key1))
	$(call anrem-assert-eq, anrem-dict-has-key, $(FALSE), $(call anrem-dict-has-key, mydict, notfound))
	$(call anrem-assert-eq, anrem-dict-has-key, $(FALSE), $(call anrem-dict-has-key, mydict,))
	$(call anrem-assert-eq, anrem-dict-in, $(TRUE), $(call anrem-dict-in, mydict, content2))
	$(call anrem-assert-eq, anrem-dict-in, $(FALSE), $(call anrem-dict-in, mydict, notfound))
	$(call anrem-assert-eq, anrem-dict-in, $(FALSE), $(call anrem-dict-in, mydict,))
	$(call anrem-assert-eq, anrem-dict-key-for, key1, $(call anrem-dict-key-for, mydict, whatever))
	$(call anrem-assert-eq, anrem-dict-key-for, $(NULL), $(call anrem-dict-key-for, mydict, notfound))
	$(call anrem-assert-eq, anrem-dict-key-for, $(NULL), $(call anrem-dict-key-for, mydict,))
