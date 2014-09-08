#
# Debug testing code
#

#$(info projects: $(call anrem-dict-keys, ANREM_PROJECTS) $(call anrem-dict-items, ANREM_PROJECTS))
#$(foreach p,$(call anrem-dict-keys, ANREM_PROJECTS),\
#	$(info modules for $(p) ==> $(call anrem-dict-keys, $(p)))\
#	$(foreach k, $(call anrem-dict-keys, $(p)),\
#		$(info $(p):$(k) = $(call anrem-dict-get, $(p), $(k)))\
#	)\
#)
#
#
$(foreach v,$(.VARIABLES),\
	$(if $(findstring |,$(v)),\
		$(info debug:module-var: $(v)),\
		$(NOP)\
	)\
)

############# testing stuff

$(warning TESTING)

#ANREM_CURRENT_MODULE := abetterpath
#
#
#
#$(!@)
#$(@)pippo := something
#$(@)pluto := not_existing
#$(@)existing := myfoo
#$(@)missing := missing
#$(@)foo[something] := myfoo
#$(@)foo[else] := mybaz
#$(@!)
#
#$(foreach k,$(call anrem-dict-keys, @foo),\
#	$(info $(k), $(@foo[$(k)]))\
#)
#
#$(foreach k,$(call anrem-dict-items, @foo),\
#	$(info item: $(k))\
#)
#
#$(info haskey yes -$(call anrem-dict-has-key, @foo, @pippo)-)
#$(info haskey no -$(call anrem-dict-has-key, @foo, @pluto)-)
#
#$(info in yes -$(call anrem-dict-in, @foo, @existing)-)
#$(info in no -$(call anrem-dict-in, @foo, @missing)-)
#
#$(info key4 yes -$(call anrem-dict-key-for, @foo, @existing)-)
#$(info key4 no -$(call anrem-dict-key-for, @foo, @missing)-)
