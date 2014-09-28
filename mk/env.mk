#
# Environment where the make process is carried on
#

# ------------------------------------ module inclusion lists and variables

# Top level directory
ANREM_TOP := $(shell pwd)

#list of modules to be traversed during the inclusion phase
#see http://perldoc.perl.org/perlre.html#Extended-Patterns
#
# The regex takes the file paths preceded by a ./ and followed by the end of the line
# this matches the output format of the directories given by ls -Rl
#
#
ANREM_MODULES := $(strip \
$(filter-out $(ANREM_COMPONENTS),\
	$(foreach _MODULE, $(shell ls -Rl | grep -oP "\.[A-Za-z0-9\/_-]*(?=:$$)"),\
		$(if $(wildcard $(_MODULE)/*.mk), $(_MODULE))\
	)\
)\
)

# this is used to signal the end of module inclusion
ANREM_MODULE_END := __anrem_end_of_module_inclusion

# ----------------------------------- module inclusion lists

# these are used to keep track of which paths should or should not
# be evaluated and the modules that have been imported so far.
#
ANREM_EXCLUDE_MODULES := $(NULL)
ANREM_EXPORTED_MODULES := $(NULL)

#
# this is used to record the paths to be ignored completely
#
ANREM_IGNORE_PATH := $(NULL)

# ---------------------------- target lists

#user defined targets list
ANREM_BUILD_TARGETS :=

#user defined clear list
ANREM_BUILD_CLEAN :=

#same as BUILD_CLEAN but for test stuff
ANREM_TEST_CLEAN_TARGETS :=

#user defined test targets list
ANREM_TEST_TARGETS :=

# ------------------------------------ Auxiliary variables

# null variable useful for calling functions with null args
NULL :=

# nop: do nothing
NOP := $(NULL)

# space variable useful in some cases
SPACE := $(NULL) $(NULL)

# comma variable useful to print commas
COMMA := ,

# formatting helpers
define NEWLINE :=


endef

# Hi emacs user! Emacs makefile-mode will complain about the following
# lines, if you change this YOU are responsible for your misery.
# Don't say I didn't warn you.
define TAB :=
	
endef

# booleans
TRUE := T
FALSE := $(NULL)

# ------------------------------------- automatic dependencies

# name of the folder in the module where the automatic dependencies are stored
ANREM_DEPS_DIR := .deps

# -------------------- cross module inclusion directory for a namespace

# name of the folder in the namespace where the links to modules are stored
ANREM_LINK_DIR := .lnk
