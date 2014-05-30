#!/bin/bash

#
# @author Alfredo Mazzinghi (qwattash)
#
# This script can be used to init an anrem project, this step is completely
# optional but may be useful to avoid manual setup
#

# get anrem source dir
SOURCE="${BASH_SOURCE[0]}"
# while source exists and is a symbolic link,
# resolve the path
while [ -h "$SOURCE" ]; do
    TARGET="$(readlink "$SOURCE")"
    # if target is an absolute path, the link is absolute
    if [[ "$TARGET" == /* ]]; then
        SOURCE="$TARGET"
    else
        SOURCE="$(dirname "$SOURCE")/$TARGET"
    fi
done
# the source script dir is
DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
if [ "${DIR##*/}" == "sh" ]; then
    ANREM_DIR=${DIR%/*}
    echo "Detected ANREM installation in $ANREM_DIR."
else
    echo "Error, couldn't find ANREM base path"
    exit 1
fi

# actions

# print usage message
function usage {
cat << EOL
Usage: $0 [OPTIONS] <command>

OPTIONS:
  -h         Show this message
  -d <dir>   Target directory, default is the current one
  -l         Use links instead of copying ANREM library files

COMMANDS:
  init     Create an ANREM project in the target directory
  update   Update an existing anrem project with the new library files
EOL
}

# init new project in target directory
function init {
if [ "$USELINK" == "1" ]; then
    ln -s "$ANREM_DIR/mk" "$TARGET_DIR/mk"
    ln -s "$ANREM_DIR/makefile" "$TARGET_DIR/makefile"
else
    cp -r "$ANREM_DIR/mk" "$TARGET_DIR"
    cp "$ANREM_DIR/makefile" "$TARGET_DIR"
fi
cp "$ANREM_DIR/LICENSE" "$TARGET_DIR/ANREM_LICENSE"
cp "$ANREM_DIR/project.mk" "$TARGET_DIR"
echo "ANREM project set up in $TARGET_DIR."
}

# update project in target directory
function update {
if [ ! -h "$TARGET_DIR/mk" ]; then
    cp -r "$ANREM_DIR/mk" "$TARGET_DIR"
fi
cp "$ANREM_DIR/LICENSE" "$TARGET_DIR/ANREM_LICENSE"
if [ ! -h "$TARGET_DIR/makefile" ]; then
    cp "$ANREM_DIR/makefile" "$TARGET_DIR"
fi
echo "ANREM project updated in $TARGET_DIR."
}

TARGET_DIR=$(pwd)
USELINK=0
# parse command input
while getopts ":hd:l" opt; do
    case "$opt" in
        h)
            usage
            exit
            ;;
        d)
            TARGET_DIR=$OPTARG
            shift
            ;;
        l)
            USELINK=1
            ;;
        \?)
            echo "Invalid option $opt"
            usage
            exit
    esac
    shift
done
# get command
ACTION=$1
case $1 in
    "init")
        init
        ;;
    "update")
        update
        ;;
    *)
        echo "invalid command"
        usage
        exit
esac
