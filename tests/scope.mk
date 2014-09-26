#
# Ignore all paths that are run with 
# recursive make
#

$(call anrem-ns-ignore, $(wildcard ./tests/test_*))
