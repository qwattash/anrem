#
# This file contains all the default rules used in anrem
# so that they are easily found and modified.
# All the rules here are intended as they have to be $(eval)'ed
# unless otherwise stated
#

#
# rule used in anrem-deps-clean
# this is the dependencies cleaning target rule
# @param $1: target name
#
define anrem-deps-clean-rule =
$1:
	rm -rf $(call anrem-current-path)/$(ANREM_DEPS_DIR)
endef
