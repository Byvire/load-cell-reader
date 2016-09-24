#!/bin/bash

# This is a helper script that makes it easy to take data in a nice way.

# The script takes as input the name of a directory in which to record data.
# The directory need not exist already. If it does exist, it should be empty.

# The script prefers to record 3 seconds of "zero" measurements, i.e. measurements of
# the load cell with 0 force applied, before and after the primary measurement.
# This is to help calibrate the results in a foolproof way.

# Prevent files from being overwritten without warning:
set -C
set -e

# Here are the file names I've been using.
PRE_ZERO='pre_zero.csv'
ACTIVE='active.csv'
POST_ZERO='post_zero.csv'

## I automatically compress the output to save disk space.
## If you do not want to do so, then comment the first
## line here and uncomment the second one:
COMPRESSION_CMD="gzip"
#COMPRESSION_CMD="cat"

# This is how the load_cell_reader program will be invoked.
# To see an explanation of the options, use the command "load_cell_reader --help"
ZERO_CMD="load_cell_reader --duration=3 --gain=16 --comparator-mode --comparator-pin 4 --battery-check-freq 2 --differential --differential-channel=3"
# This is how the program will be invoked during the main part of the test.
ACIVE_CMD="load_cell_reader --duration=0 --gain=16 --comparator-mode --comparator-pin 4 --battery-check-freq 2 --differential --differential-channel=3"

#ZERO_CMD="echo foo"
#ACTIVE_CMD="python /home/oliver/Repo/load-cell-reader/test.py"

# Clearer variable names
OUTPUT_DIR="$1"

if [ -z "OUTPUT_DIR" ] ; then
    echo 'Error:' 1>&2
    echo 'Not enough arguments. What should the name of the output be?' 1>&2
    echo "Example: $0 nylon_data" 1>&2
    exit 1
fi


# Exit if the directory exists and is nonempty
if [ -d "$OUTPUT_DIR" ] && [[ -n $(ls "$OUTPUT_DIR" | head) ]] ; then
    echo "life is shit" 1>&2
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

# Do the measurements:

echo "Measuring 3 seconds of zero load for reference." 1>&2
echo "Don't apply a load to the load cell during this part." 1>&2
$ZERO_CMD | $COMPRESSION_CMD > "$OUTPUT_DIR/$PRE_ZERO"
echo "Ready to do the fatigue test." 1>&2
echo "Press ENTER to stop collecting data:" 1>&2
$ACTIVE_CMD | $COMPRESSION_CMD > "$OUTPUT_DIR/$ACTIVE"
echo "Measuring 3 seconds of zero load for reference." 1>&2
echo "Don't apply a load to the load cell during this part." 1>&2
$ZERO_CMD | $COMPRESSION_CMD > "$OUTPUT_DIR/$POST_ZERO"
