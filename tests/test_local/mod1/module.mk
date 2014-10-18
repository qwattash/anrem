

$(call anrem-local-set, module-var, variable_in_module_1)

$(call anrem-ns-local-set, ns-var-mod1, ns-variable-from-mod1)

# test a variable containing a list
$(call anrem-local-set, module-list-var, module_1_list_a module_1_list_b module_1_list_c)

$(call anrem-test):
	$(call anrem-warn, local base|MODULE 1)
	$(call anrem-assert-eq, anrem-local-get module-var in mod1, variable_in_module_1, $(call anrem-local-get, module-var))
	$(call anrem-assert-eq, anrem-ns-local-get ns-var-mod1, ns-variable-from-mod1, $(call anrem-ns-local-get, ns-var-mod1))
	$(call anrem-assert-eq, @ module-var in mod1, variable_in_module_1, $(@module-var)) 
	$(call anrem-assert-eq, & ns-var-mod1, ns-variable-from-mod1, $(&ns-var-mod1))
	$(call anrem-assert-eq, get list variable, module_1_list_a module_1_list_b module_1_list_c, $(call anrem-local-get, module-list-var))
	$(call anrem-assert-eq, @ get list variable, module_1_list_a module_1_list_b module_1_list_c, $(@module-list-var))
# variables from other and namespaces
	$(call anrem-assert-eq, anrem-ns-local-get ns-var-mod4, ns-variable-from-mod4, $(call anrem-ns-local-get, ns-var-mod4))
	$(call anrem-assert-eq, & ns-var-mod4, ns-variable-from-mod4, $(&ns-var-mod4))
	$(call anrem-assert-eq, anrem-ns-local-get ns-var-mod2, ns-variable-from-mod2, $(call anrem-ns-local-get, ns-var-mod2))
	$(call anrem-assert-eq, & ns-var-mod2, ns-variable-from-mod2, $(&ns-var-mod2))
	$(call anrem-assert-eq, anrem-ns-local-get ns-var-mod3, ns-variable-from-mod3, $(call anrem-ns-local-get, ns-var-mod3))
	$(call anrem-assert-eq, & ns-var-mod3, ns-variable-from-mod3, $(&ns-var-mod3))
