#!/bin/sh
# usage: timing.sh <eval-dir>/<config> <tokens> <duration_ms>
D="$(dirname "$0")/iteration-1/$1/run-1"; mkdir -p "$D"
python3 -c "import json,sys; json.dump({'total_tokens': int(sys.argv[1]), 'duration_ms': int(sys.argv[2]), 'total_duration_seconds': round(int(sys.argv[2])/1000, 1)}, open(sys.argv[3], 'w'))" "$2" "$3" "$D/timing.json"
