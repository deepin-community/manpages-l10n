#!/bin/sh
set -e

tmp=$(mktemp)
merged=$(mktemp)

git checkout CHANGES.md
./collect-changes.sh > "$tmp"
sed -i -e "s/ *$//" "$tmp"
cat "$tmp" CHANGES.md > "$merged"
mv "$merged" CHANGES.md
rm "$tmp"
