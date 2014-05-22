#
# Test mk module
#
#

__module_inclusion_ack += src/c/f/b
__module_current_path += $(call anrem-current-path)


$(call anrem-build, src/c/f/b/build):
	@echo -n ""

$(call anrem-clean):
	@echo -n ""

$(call anrem-test):
	@echo -n ""

