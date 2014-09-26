
$(<@)
$(@)module-var := ns2_variable_in_module_4
$(@>)

$(<&)
$(&)ns-var-mod4 := ns2_ns-variable-from-mod4
$(&>)

$(call anrem-test):
	$(call anrem-warn, local ns2_|MODULE 4)
	$(call anrem-assert-eq, anrem-local-get module-var in mod4, ns2_variable_in_module_4, $(call anrem-local-get, module-var)) 
	$(call anrem-assert-eq, anrem-ns-local-get ns-var-mod4, ns2_ns-variable-from-mod4, $(call anrem-ns-local-get, ns-var-mod4))
	$(call anrem-assert-eq, @ module-var in mod4, ns2_variable_in_module_4, $(@module-var)) 
	$(call anrem-assert-eq, & ns-var-mod4, ns2_ns-variable-from-mod4, $(&ns-var-mod4))
# variables from other and namespaces
	$(call anrem-assert-eq, anrem-ns-local-get ns-var-mod1, ns2_ns-variable-from-mod1, $(call anrem-ns-local-get, ns-var-mod1))
	$(call anrem-assert-eq, & ns-var-mod1, ns2_ns-variable-from-mod1, $(&ns-var-mod1))
	$(call anrem-assert-eq, anrem-ns-local-get ns-var-mod2, ns2_ns-variable-from-mod2, $(call anrem-ns-local-get, ns-var-mod2))
	$(call anrem-assert-eq, & ns-var-mod2, ns2_ns-variable-from-mod2, $(&ns-var-mod2))
	$(call anrem-assert-eq, anrem-ns-local-get ns-var-mod3, ns2_ns-variable-from-mod3, $(call anrem-ns-local-get, ns-var-mod3))
	$(call anrem-assert-eq, & ns-var-mod3, ns2_ns-variable-from-mod3, $(&ns-var-mod3))
