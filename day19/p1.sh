#!/bin/bash

pat="^($(head --lines 1 data.txt | sed -e 's/,/|/g' -e 's/ //g'))*\$"

echo $pat
# the result:
echo "RESULT:"
tail -n +3 data.txt | grep -c -E $pat
