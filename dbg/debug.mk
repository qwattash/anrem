

$(call anrem-target, debug): $(call anrem-target-group-depend, link)
	$(info $(ANREM_TEST_TARGETS))
