#
# Test the dictionary utility functions
#
#

# define a dictionary
mydict[key1] = content1
mydict[key2] = content2

myotherdict[key3] = content3
myotherdict[key4] = content4

mydict[key1] = whatever

mydict_keys_expected = key1 key2
mydict_keys = $(NULL)
myotherdict_keys_expected = key3 key4
myotherdict_keys = $(NULL)

$(foreach item,$(call anrem-dict-keys, mydict),\
	$(eval mydict_keys = $(mydict_keys) $(item))\
)

$(foreach item,$(call anrem-dict-keys, myotherdict),\
	$(eval myotherdict_keys = $(myotherdict_keys) $(item))\
)

mydict_content_expected = whatever content2
mydict_content = $(NULL)

myotherdict_content_expected = content3 content4
myotherdict_content = $(NULL)

$(foreach item,$(call anrem-dict-items, mydict),\
	$(eval mydict_content = $(mydict_content) $(item))\
)

$(foreach item,$(call anrem-dict-items, myotherdict),\
	$(eval myotherdict_content = $(myotherdict_content) $(item))\
)

$(call anrem-test):
#	here do the output, functions have already been called during evalutation of the mk file
	@echo "expected: $(mydict_keys_expected)"
	@echo "found: $(mydict_keys)"
	@echo "expected: $(myotherdict_keys_expected)"
	@echo "found: $(myotherdict_keys)"
	@echo "expected: $(mydict_content_expected)"
	@echo "found: $(mydict_content)"
	@echo "expected: $(myotherdict_content_expected)"
	@echo "found: $(myotherdict_content)"
	@echo "haskey mydict,key1: $(call anrem-dict-has-key, mydict, key1)"
	@echo "haskey mydict,notfound: $(call anrem-dict-has-key, mydict, notfound)"
	@echo "in mydict,content2: $(call anrem-dict-in, mydict, content2)"
	@echo "in mydict,notfound: $(call anrem-dict-in, mydict, notfound)"
	@echo "keyfor mydict,whatever -> key1: $(call anrem-dict-key-for, mydict, whatever)"
	@echo "END"
