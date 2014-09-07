#
# declare here namespace in ./src_1/namespace_1
#

# use custom name to avoid conflict among ./src_2/confilcts/namespace_1 and ./src_1/namespace_1
$(call anrem-ns-register, ./src_1/namespace_1, src_1_ns_1)

# register a namespace with its default name
$(call anrem-ns-register, ./src_1/namespace_2)
