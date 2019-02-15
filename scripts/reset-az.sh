#!/usr/bin/env bash
echo "Re-setting Demo"

# Force push HEAD to baseline
echo "Reverting master to baseline tag"
git fetch --tags
git checkout master
git reset --hard baseline
git push com baseline:master -f
