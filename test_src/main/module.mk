#
# This is a template for a module makefile.
# The goal of this file is to show capabilities of the ANREM system,
# and provide example use cases for which ANREM has been designed.
#

# get current module path, this can be used later for a number of
# purposes
CURRENT := $(call anrem-current-path)

# these are local variables defined with the help of the auto-inclusion system CURRENT path
# local variables are notationally expensive as you can see below, so use them only if it
# is really necessary
# notice also that the BUILDDIR variable is defined into project.mk
# project.mk can be used almost for any project-specific functions or variables that
# do not fit into mk/config.mk
BUILD_TARGETS_$(CURRENT) := $(addprefix $(BUILDDIR)/,hello)

#
# the MOD_calc variable points to the path of the calc module wherever it is
# this reference is created by ANREM automatically and can be used for cross-module linking
# So the the current module path will be accessible from other modules as $MOD_main.
# The only drawback in this is that the naming is automatic and if you name two modules with
# the same name you may end up with an error.
# To avoid this you get the possibility to define a MOD var for any module path so that you
# can have meaningful names while avoiding collisions. This should not be a very frequent
# problem though!
# The default behaviour is progressively use parts of the module path in the MOD_<name> variable
# <name> part until no conflict occur, however this makes the name dependant on the path, so
# pay attention to that, if you do not want troubles just put a custom name (as done below for
# MOD_custom for test_src/calc/main) in project.mk
CALC_obj_$(CURRENT) := $(MOD_calc)/calc.o $(MOD_custom)/calcmain.o

# for example the required files are defined as non-local
HELLO_deps = $(addprefix $(CURRENT)/,hello.c)
HELLO_obj = $(HELLO_deps:%.c=%.o)

# this is autogenerated by anrem-target:
# $(call anrem-target, my_target1.o): path := $(CURRENT)
# however notice how the use of the local variable makes everything less simple to read
$(call anrem-target, $(BUILD_TARGETS_$(CURRENT)) ): $(HELLO_obj) $(CALC_obj_$(CURRENT))
# note that hello.o requires calc.o which is generated by the calc module
# the problem is solved by including it using the $MOD_calc base name
	$(CC) $^ -o $@

$(call anrem-target, $(HELLO_obj)): $(HELLO_deps)
# note that hello.c includes calc.h which is in another module
# the problem is solved by using the $MOD_calc as a possible include dir
	$(CC) -c -I $(MOD_calc) -I $(MOD_custom) -o $@ $^

$(call anrem-target, hello_clean):
	rm -f $(path)/*.o
	rm -f $(BUILD_TARGETS_$(CURRENT))

# those add to the global anrem build and clean targets the targets defined above
# in future they may be merged into anrem-target directly
$(call anrem-build, $(BUILD_TARGETS_$(CURRENT)))
$(call anrem-clean, hello_clean)
