# get current module path, this can be used later for a number of
# purposes
CURRENT := $(call anrem-current-path)

$(call anrem-build, $(addprefix $(CURRENT)/,hello_build)): $(CURRENT)/hello_target
	touch $@

$(call anrem-target, $(addprefix $(CURRENT)/,hello_target)):
	touch $@

$(call anrem-clean):
	rm $(addprefix $(path)/,hello_build hello_target)

$(call anrem-test):
	touch $(path)/hello_test

$(call anrem-test-clean):
	rm $(addprefix $(path)/,hello_test)
