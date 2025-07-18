#!/usr/bin/env bash
# SPDX-License-Identifier: MIT

# This script checks consistency between the filenames and the page title.
# Usage: ./scripts/wrong-filename.sh

# Output file for recording inconsistencies
OUTPUT_FILE="inconsistent-filenames.txt"
# Remove existing output file (if any)
rm -f "$OUTPUT_FILE"
touch "$OUTPUT_FILE"

IGNORE_LIST=("jc.json" "mc.cli" "mc.fm" "qm move disk" "umount" "rename" "pacman  d" "pacman  f" "pacman  q" "pacman  r" "pacman  s" "pacman  t" "pacman  u" "parted" "print.runmailcap" "print.win" "python  m json.tool")

set -e

# Iterate through all Markdown files in the 'pages' directories
find pages* -name '*.md' -type f | while read -r path; do
  # Extract the expected command name from the filename
  COMMAND_NAME_FILE=$(basename "$path" | head -c-4 | sed 's/\.fish//' | sed 's/\.js//' | sed 's/\.1//' | sed 's/\.2//' | sed 's/\.3//' | tr '-' ' ' | tr '[:upper:]' '[:lower:]')

  # Extract the command name from the first line of the Markdown file
  COMMAND_NAME_PAGE=$(head -n1 "$path" | tail -c+3 | sed 's/--//' | tr '-' ' ' | tr '[:upper:]' '[:lower:]')

  # Check if there is a mismatch between filename and content command names
  if [[ "$COMMAND_NAME_FILE" != "$COMMAND_NAME_PAGE" && ! ${IGNORE_LIST[*]} =~ $COMMAND_NAME_PAGE ]]; then
    echo "Inconsistency found in file: $path: $COMMAND_NAME_PAGE should be $COMMAND_NAME_FILE" >> "$OUTPUT_FILE"
  fi
done
