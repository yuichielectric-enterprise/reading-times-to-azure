#!/usr/bin/env bash

# Fail if no token
: ${GITHUB_TOKEN?"Please set environment variable GITHUB_TOKEN to the GitHub access token"}

# Gettin the original content
git remote add office-tools git@octodemo.com:office-tools/reading-time-app.git
git fetch office-tools

# Resting our HEAD to golden repository
git checkout master
git reset --hard office-tools/master

# Generating personal travis token
travis encrypt TOKEN=$GITHUB_TOKEN --add  -e https://travis.octodemo.com/api --debug
git commit -am "Adding my travis token after demo update"

# Updating master and our baseline to revert to later on
git push origin master:baseline -f
git push origin master -f

bash ./scripts/reset-demo.sh
