#!/usr/bin/env bash

TMPDIR=$(mktemp -d)

zpool list -H -o name | xargs zpool scrub -w \
  2>"$TMPDIR/stderr.txt" 1>"$TMPDIR/stdout.txt"

# echo "No errors
# Two lines" > "$TMPDIR/stdout.txt"
# echo "" > "$TMPDIR/stderr.txt"

STDOUT_LINES=$(cat "$TMPDIR/stdout.txt" | wc -l)
STDERR_LINES=$(cat "$TMPDIR/stderr.txt" | wc -l)

echo "**stdout lines**: $STDOUT_LINES
**stderr lines**: $STDERR_LINES" | \
  webhook-notifier home-server-updates - -t "ZFS Scrub results" -n -a "$TMPDIR/stderr.txt" -a "$TMPDIR/stdout.txt"
