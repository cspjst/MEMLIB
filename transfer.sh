#!/bin/sh
# Transfer a satisfactory build: bin/MEM.lib -> lib/, src/MEM/*.h -> include/MEM/
set -e
cd "$(dirname "$0")"

LIB=bin/MEM.lib

if [ ! -f "$LIB" ]; then
    echo "transfer: $LIB not found - build first (./cmk.sh && ./bld.sh in src)" >&2
    exit 1
fi

mkdir -p lib include/MEM

cp "$LIB" lib/

# clear old headers so ones deleted from src/MEM don't linger
rm -f include/MEM/*.h
cp src/MEM/*.h include/MEM/

echo "transferred: lib/MEM.lib + $(ls include/MEM/*.h | wc -l | tr -d ' ') headers -> include/MEM/"
