#
# Environment where the make process is carried on
#

# Top level directory
ANREM_TOP := $(shell pwd)

#list of modules to be traversed during the inclusion phase
#see http://perldoc.perl.org/perlre.html#Extended-Patterns
ANREM_MODULES := $(strip \
$(filter-out $(ANREM_COMPONENTS),\
	$(foreach _MODULE, $(shell ls -Rl | grep -oP "(?<=^\.\/)[A-Za-z0-9\/_-]*(?=:$$)"),\
		$(if $(wildcard $(_MODULE)/*.mk), $(_MODULE))\
	)\
)\
)

#user defined targets list
ANREM_BUILD_TARGETS :=

#user defined debug targets
#TODO not yet implemented
DEBUG_TARGETS :=

#user defined clear list
ANREM_BUILD_CLEAN :=

#same as BUILD_CLEAN but for debug stuff
DEBUG_CLEAN :=

#user defined test targets list
ANREM_TEST_TARGETS :=

# null variable useful for calling functions with null args
NULL :=

# space variable useful in some cases
SPACE := $(NULL) $(NULL)

# stores names of MOD_<module_name> variables that have been exported so far
# this is used to detect and manage clashes in module vars naming
MOD_VAR_NAMES := $(NULL)
# this is used along MOD_VAR_NAMES to keep track of modules for which a MOD
# variable is defined
EXPORTED_MODULES := $(NULL)
