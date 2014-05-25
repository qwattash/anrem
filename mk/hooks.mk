#
#
#
#
#
#


#
# anrem-hook-makedepend(name, dependency_file, source)
# @param $1: matched name in the rule (say %.o: %.c matches file.o, the argument value is "file")
# @param $2: where the hook should store the dependency list
# @param $3: source file(s) for which the hook should provide the dependencies
define anrem-hook-makedepend =
gcc -MM -MP -MT $$@ -MF $(deps)/$$*.d $$<
endef

define anrem-hook-auto-target-command =
gcc -c -o $$@ $$<
@echo "auto rule #TODO"
endef


define anrem-hook-makedepend-2 =
gcc -MM -MP -MT $1 -MF $2 $3
endef


define anrem-hook-makedepend-3 =
gcc -MM -MP -MT $1 -MF $2 $3
endef
