
# get current module path, this can be used later for a number of
# purposes
CURRENT := $(call anrem-current-path)

deps_2 := $(addprefix $(CURRENT)/,mod2.c)
obj_2 := $(patsubst %.c,%.o,$(deps_2))

# register target to group build_group
$(call anrem-target-group-add, build_group, $(obj_2))

$(call anrem-target, $(obj_2)): $(deps_2)
	$(CC) -c -o $@ $<

$(call anrem-clean):
	rm -f $(path)/*.o
