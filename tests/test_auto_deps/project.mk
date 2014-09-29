#
# This test is meant to be run in a separate make environment
#
#

#################################
# Fixture: test automatic dependendencies generation
#

# load helpers in the recursive make environment
$(call anrem-test-load-helpers)

# enable test logging
$(call anrem-test-set-log, test.log)

## register the main test target for the nested module
test_main: src/hello
# check that deps are generated for both groups
	@$(call anrem-assert-diff-sh, hello.d, src/.deps/hello.d, src/hello.d.sample)
	@$(call anrem-assert-diff-sh, world.d, src/.deps/world.d, src/world.d.sample)
	@$(call anrem-assert-diff-sh, say.d, src/.deps/say.d, src/say.d.sample)
	@$(call anrem-assert-diff-sh, name.d, src/.deps/name.d, src/name.d.sample)
# check that compiled is built
	$(call anrem-assert-file-exist, Build output completed, hello)
# check depclean target
	@make depclean -C . > /dev/null
	$(call anrem-assert-not-exists-sh, hello.d, src/.deps/hello.d)
	$(call anrem-assert-not-exists-sh, world.d, src/.deps/world.d)
	$(call anrem-assert-not-exists-sh, say.d, src/.deps/say.d)
	$(call anrem-assert-not-exists-sh, name.d, src/.deps/name.d)
# check custom hook
	@make clean -C . > /dev/null
	@make src/hello -C . > build_output.txt
#	@$(call anrem-assert-diff-sh, Build target output, build_output.txt, build_output.sample)
