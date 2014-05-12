# custom module variables for modules with the same name
# for instance test_src/main and test_src/calc/main would
# end up in the same variable MOD_main
# this is unfortunate since the behaviour for selecting the
# real content of MOD_main is undetermined.
# A solution could be detecting such conflicts and automatically
# use a different name such as MOD_calc_main and MOD_test_src_main:
# this is the default behaviour of ANREM in order to avoid name
# clashed on the module naming.
# However you may argue that the naming is cumbersome and it is also
# undetermined in the sense that in theory long names can result up
# to the full path of the module, making the whole thing useless;
# also this makes the NAME dependant on the PATH, an this is
# the thing that we wanted to avoid in the first place.
# To fix this the user is given the opportunity (and is strongly encouraged)
# to define himself the variables for conflicting modules in the project.mk
# as follows.
#$(call anrem-def-modx, test_src/calc/main, custom)

# for some other reasons, and because of name clashes you may want to ignore the
# generation of MOD variables for some modules, this can be done by
#$(call anrem-exclude-modx, test_src/calc/main)

# Now, the two function calls above are commented to show the alternative method for
# defining custom MOD variable names and ignoring modules, this can be done locally
# within each module by simply renaming the ".mk" file to a name.
# The following patterns are accepted:
# "module.mk": automatic MOD variable naming using the folder name(s)
# "_*.mk": everything started with a "_" is treated as an excluded module for the MOD variables
# 	declaration system (just like anrem-exclude-modx)
# "*.mk": everything not starting with a "_" and not named "module.mk" is treated as a custom name
#	to use (just like anrem-def-modx)
