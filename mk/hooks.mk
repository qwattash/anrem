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
$(info MT $1 MF $2 TGT $3)\
gcc -MM -MP -MT $1 -MF $2 $3
endef

define anrem-hook-auto-target-rule =
gcc -c -o $$@ $$<
endef
