
# get current module path, this can be used later for a number of
# purposes
CURRENT := $(call anrem-current-path)

build_target := $(addprefix $(CURRENT)/,hello)

$(call anrem-target, $(build_target)): $(CURRENT)/hello.o $(call anrem-target-group-depend, build_group)
	$(CC) -o $@ $< $(call anrem-target-group-members, build_group)

$(call anrem-target, $(CURRENT)/hello.o): $(CURRENT)/hello.c
	$(CC) -c -o $@ $(addprefix -I ,$(call anrem-target-group-modules, build_group)) $<

$(call anrem-clean):
	rm -f $(build_target)
	rm -f $(path)/*.o
