#
# This files contains the definition of
# the shorthand tags used in various parts
# of anrem
#
#

######### Testing tags

# tee to log file a shell command output
# default is $(>>)
#
ANREM_TEST_TAG_LOG := >>

######### Local variables blocks

# local variable definition block start tag
# default is $(!@)
#
ANREM_LOCAL_TAG_BLK_START := <@

# local variable definition block end tag
# default is $(@!)
#
ANREM_LOCAL_TAG_BLK_END := @>

# local variable definition tag
# default is $(@), which gives $(@)var_name := value
#
ANREM_LOCAL_TAG_SET := @

# local variable definition tag
# default is $(@), which gives $(@var_name) # returns value
#
ANREM_LOCAL_TAG_GET := @

# namespace local variable definition block start tag
# default is $(!&)
#
ANREM_LOCAL_NS_TAG_BLK_START := <&

# namespace local variable definition block end tag
# default is $(&!)
#
ANREM_LOCAL_NS_TAG_BLK_END := &>

# namespace local variable definition tag
# default is $(&), which gives $(&)var_name := value
#
ANREM_LOCAL_NS_TAG_SET := &

# namespace local variable definition tag
# default is $(&), which gives $(&var_name) # returns value
#
ANREM_LOCAL_NS_TAG_GET := &
