
# variables from other and namespaces

$(<@)
$(@)module-var := ns1_variable_in_module_3
$(@>)

$(<&)
$(&)ns-var-mod3 := ns1_ns-variable-from-mod3
$(&>)


$(call anrem-test):
	$(call anrem-warn, local ns1_|MODULE 3)
	$(call anrem-assert-eq, anrem-local-get module-var in mod3, ns1_variable_in_module_3, $(call anrem-local-get, module-var)) 
	$(call anrem-assert-eq, anrem-ns-local-get ns-var-mod3, ns1_ns-variable-from-mod3, $(call anrem-ns-local-get, ns-var-mod3))
	$(call anrem-assert-eq, @ module-var in mod3, ns1_variable_in_module_3, $(@module-var)) 
	$(call anrem-assert-eq, & ns-var-mod3, ns1_ns-variable-from-mod3, $(&ns-var-mod3))
# variables from other and namespaces
	$(call anrem-assert-eq, anrem-ns-local-get ns-var-mod4, ns1_ns-variable-from-mod4, $(call anrem-ns-local-get, ns-var-mod4))
	$(call anrem-assert-eq, & ns-var-mod4, ns1_ns-variable-from-mod4, $(&ns-var-mod4))
	$(call anrem-assert-eq, anrem-ns-local-get ns-var-mod2, ns1_ns-variable-from-mod2, $(call anrem-ns-local-get, ns-var-mod2))
	$(call anrem-assert-eq, & ns-var-mod2, ns1_ns-variable-from-mod2, $(&ns-var-mod2))
	$(call anrem-assert-eq, anrem-ns-local-get ns-var-mod1, ns1_ns-variable-from-mod1, $(call anrem-ns-local-get, ns-var-mod1))
	$(call anrem-assert-eq, & ns-var-mod1, ns1_ns-variable-from-mod1, $(&ns-var-mod1))
