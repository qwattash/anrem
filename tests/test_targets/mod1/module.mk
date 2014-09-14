# get current module path, this can be used later for a number of
# purposes
CURRENT := $(call anrem-current-path)

$(call anrem-build, $(addprefix $(CURRENT)/,hello_build)): $(CURRENT)/hello_target
	touch $@

$(call anrem-target, $(addprefix $(CURRENT)/,hello_target)):
	touch $@

$(call anrem-clean, $(CURRENT)_hello_clean):
	rm $(addprefix $(CURRENT)/,hello_build hello_target)

$(call anrem-test, $(addprefix $(CURRENT)/,hello_test)):
	touch $@

$(call anrem-test-clean, $(CURRENT)_hello_test_clean):
	rm $(addprefix $(CURRENT)/,hello_test)
