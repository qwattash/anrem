#
# Test mk module
#
#

__module_inclusion_ack += src/b
__module_current_path += $(call anrem-current-path)


$(call anrem-build, src/b/build):
	@echo -n ""

$(call anrem-clean):
	@echo -n ""

$(call anrem-test):
	@echo -n ""
