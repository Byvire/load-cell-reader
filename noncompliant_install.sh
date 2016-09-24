#!/bin/bash

# This script installs the software I wrote, more or less.
# It's a hacky solution, and I don't recommend it unless
# your Raspberry Pi install is purely dedicated to running
# this test.

set -C

if [ $(id -u) = 0 ] ; then
    # Don't use sudo to run this script, or
    # Bad Things will happen.
    echo "This shouldn't be run as root. Aborting!" 1>&2
    exit 1
fi

# If home directory exists and ./load_cell_reader exists...
if [ [ -d ~ ] -a [ -e ./load_cell_reader ] ] ; then
    mkdir -p ~/bin
    chmod 744 ./load_cell_reader
    # The symbolic links means that you won't need to run
    # this script again
    ln -s ./load_cell_reader  ~/bin/load_cell_reader

    if [[ -e ./take_data.sh ]] ; then
	# take_data is the command you actually want
	# to use. It has nice comments.
	chmod 744 ./take_data.sh
	ln -s ./take_data.sh ~/bin/take_data
    fi
fi

# If you add the line `export PATH="$PATH":"$HOME"/bin` to
# your ~/.bashrc file, then you'll be able to 
