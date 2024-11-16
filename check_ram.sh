#!/bin/bash

# Memory thresholds (in percentage)
memWarning=${1:-75} # Default to 75 if nothing is supplied!
memCritical=${2:-90}

# Grab memory details, in MB. Only the third of these is really important, but then first two are used to show more data.
memTotal=$(free -m | awk '/Mem:/ {print $2}') # Grab the second field, which is the total.
memUsed=$(free -m | awk '/Mem:/ {print $3}')
memPerc=$(( memUsed * 100 / $memTotal )) # Calc percentage by er... mathy stuff.

# Output memory details and set Nagios status
# In nagios, 0 means clear, 1 means warning, 2 means critical, 3 means unknown.
if [ "$memPerc" -ge "$memCritical" ]; then
    echo "CRITICAL - Memory usage is $memPerc% ($memUsed MB / $memTotal MB)."
    exit 2
elif [ "$memPerc" -ge "$memWarning" ]; then
    echo "WARNING - Memory usage is $memPerc% ($memUsed MB / $memTotal MB)."
    exit 1
elif [ "$memPerc" -le "$memWarning" ]; then
    echo "OK - Memory usage is $memPerc% ($memUsed MB / $memTotal MB)."
    exit 0
else 
    echo "Could not read memory statistics."
    exit 3 # Unknown, something went really wrong somewhere.
fi
