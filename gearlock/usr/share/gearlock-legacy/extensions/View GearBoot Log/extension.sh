#!/bin/bash
LOG_FILE="$GTMP/gearboot.log"
test -e "$LOG_FILE" && cat "$LOG_FILE" || echo -e "\n++++ GearBoot log file is not present (It's not an error)"
