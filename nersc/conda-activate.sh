#!/bin/bash

# Determine the directory containing this script
if [[ -n $BASH_VERSION ]]; then
    _SCRIPT_LOCATION=${BASH_SOURCE[0]}
    _SHELL="bash"
elif [[ -n $ZSH_VERSION ]]; then
    _SCRIPT_LOCATION=${funcstack[1]}
    _SHELL="zsh"
else
    echo "Only bash and zsh are supported"
    return 1
fi

_BCCP_DIR=$(dirname "$_SCRIPT_LOCATION")

if ! [ $# == 1 ]; then
    (>&2 echo "Error: expect one argument.")
    (>&2 echo "    (Got $@)")
    return 1
fi

case $1 in
    2.7 | 3.7 | 3.6 )
    ;;

    *)
    (>&2 echo "give a Python version number 2.7, 3.6 or 3.7")
    (>&2 echo "    (Got $1)")
    return 1
    ;;
esac 

_ENVNAME=bcast-bccp-$1

source $_BCCP_DIR/conda/envs/$_ENVNAME/bin/activate-bcast
