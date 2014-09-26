##########################
# 
# automatic dependencies
# Functions used to generate and manage automatic dependencies
# 



#
# Credits goes to Tom Tromey <tromey@cygnus.com> who devised the method for GNU automake
# Also many thanks for reporting the method to Paul D. Smith <psmith@gnu.org> at
# mad-scientist.net/make/autodep.html
#
# WARNING: The automatic dependencies functionalities are gcc/g++ only
# in the future this may change
#

#
# Define an automatic target, in general an automatic target in ANREM is
# a target for which the dependencies are generated automatically by the
# system, based on the files included by the files involved in the rule.
#
# There are 2 types of automatic targets in make 
# i) module-global automatic target:
#	has global scope inside the module and its rule is defined by the user (yes, you)
#	an example is:
#	<module_path>/%.o: <module_path>/%.c
#		$(CC) $(CFLAGS) -I $(MOD_includes) -c -o $@ $<
#	# assuming that the include flag is not in CFLAGS
#
# ii) target-specific automatic target:
#	basically it is an automatic target defined only for a group of user-defined targets
#	an example is:
#	$(custom_targets): <module_path>/%.o: <module_path>/%.c
#		$(CC) $(CFLAGS) -I $(MOD_includes) -c -o $@ $<
#	# assuming that the include flag is not in CFLAGS
#
# You don't have to specify a rule in types (i) and (iv), while a rule declaration is expected
# for cases (ii) and (iii) after the invocation of this function
#
# The job of ANREM is making it easy for you to create those targets and not worry about
# the dependency files creation, deletion and updating.
# The creation of dependency files is parametrised using a call hook with the following
# signature:
# @param name: matched name in the rule (say %.o: %.c matches file.o, the argument value is "file.o")
# @param dependency_file: where the hook should store the dependency list
# @param source: source file(s) for which the hook should provide the dependencies
# anrem-hook-makedepend(name, dependency_file, source)
# The hook can be registered using the hook registration system as normal with type "anrem-hook-makedepend"
# or can be given directly at the time of declaration of the target/rule as an argument

# This is the simplest solution to the problem, it leaves to the user the 
# task of defining the targets and calling the mkdeps hook resolver
# Notice that the patters should always be restricted to the current module path
# unless a global target is explicitly wanted, this will help avoiding clashed
# among rules in different modules.
#
# This is needed for creating the automatic dependencies in a target
# A sample target declaration is in the form:
# $(call anrem-target, $(path)/%.o): $(path)/%.c
# OR
# $(call anrem-target, $(objects)): $(path)/%.o: $(path)/%.c
#	$(call anrem-mkdeps, $@, $<)
#	#custom rule
#	$(CC) $(CFLAGS) ...
#
# this function simply calls the hook function for mkdeps
#
# @param $1 target name
# @param $2 dependency name
# @param [$3] hook function to call
#
define anrem-mkdeps =
	@mkdir -p $(path)/$(ANREM_DEPS_DIR)
	$(call $(call anrem-optarg, $3, anrem-hook-makedepend), \
		$(strip $(call anrem-expand-local, $1)),\
		$(path)/$(ANREM_DEPS_DIR)/$(subst $(dir $(call anrem-expand-local, $1)),$(NULL),$(basename $(call anrem-expand-local, $1))).d,\
		$(strip $(call anrem-expand-local, $2))\
	)
endef
