#!/usr/bin/env bash

ds() {
  date --date="$1 weeks ago" +%Y-%m-%d
}
BRANCH=master # your branch here

echo "Week,Lines Changed"
for week in {80..1}
do
  # git log outputs lines like:
  # 11        10      path/to/your/file.java
  #  => add first two columns with awk
  lines=$(git --no-pager log --after="$(ds "$week")" --before="$(ds $(("$week" - 1)))" --format=format: --numstat $BRANCH | awk '{s+=$1; s+=$2} END {print s}')
  echo "$(ds "$week"),$lines"
done
