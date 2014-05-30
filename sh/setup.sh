#!/bin/bash

#
# @author: Alfredo Mazzinghi (qwattash)
#
# This files install the anrem script in your system
#

# target dir
TARGET="/usr/local/bin"


# install to TARGET dir
function install {
    SRC_DIR=$(pwd)
    if [ -f "$TARGET" ]; then
        echo "$TARGET is not a directory"
        exit 1
    elif [ ! -e "$TARGET" ]; then
        mkdir -p "$TARGET"
    fi
    ln -s "$SRC_DIR/anrem.sh" "$TARGET/anrem"
    if [ $? -eq 0 ]; then
        echo "ANREM script successfully installed in $TARGET, anrem directory is $SRC_DIR."
    else
        echo "Error while installing ANREM."
    fi
}

# remove anrem installed script from TARGET dir
function remove {
    unlink "$TARGET/anrem"
    if [ $? -eq 0 ]; then
        echo "ANREM successfully uninstalled."
    else
        echo "Error while uninstalling ANREM."
    fi
}

# usage of setup script
function usage {
cat <<EOF
Usage $0 [OPTIONS] <command>

OPTIONS:
  -h        Show help
  -d <dir>  Target directory, default $TARGET
EOF
}


while getopts ":hd:" opt; do
    case $opt in
        h)
            usage
            exit
            ;;
        d)
            TARGET="$OPTARG"
            shift
            ;;
        \?)
            echo "Invalid option"
            usage
            exit
            ;;
    esac
    shift
done
# get action
ACTION=$1

case "$ACTION" in
    "install")
        install
        ;;
    "remove")
        remove
        ;;
    *)
        echo "Invalid command"
        usage
        ;;
esac
