#
# Ignore all paths that are run with 
# recursive make
#

$(call anrem-ns-ignore, $(wildcard $(ANREM_BASE)/tests/test_*))
