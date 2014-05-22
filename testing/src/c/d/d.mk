#
# Test mk module
#
#

__module_inclusion_ack += src/c/d
__module_current_path += $(call anrem-current-path)


$(call anrem-build, src/c/d/build):
	@echo "TODO"

$(call anrem-clean):
	@echo "TODO"

$(call anrem-test):
	@echo "TODO"

