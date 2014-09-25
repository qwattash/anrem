
# get current module path, this can be used later for a number of
# purposes
CURRENT := $(call anrem-current-path)

deps_1 := $(addprefix $(CURRENT)/,mod1.c)
obj_1 := $(patsubst %.c,%.o,$(deps_1))

# register target to group build_group
$(call anrem-target-group-add, build_group, $(obj_1))

$(call anrem-target, $(obj_1)): $(deps_1)
	$(CC) -c -o $@ $<

$(call anrem-clean):
	rm -f $(path)/*.o
