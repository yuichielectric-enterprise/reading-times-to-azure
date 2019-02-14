#!/usr/bin/env bash

# Fail if no token
: ${GITHUB_TOKEN?"Please set environment variable GITHUB_TOKEN to the GitHub access token"}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Getting the original content
git remote add baseline git@octodemo.com:baseline/reading-time-demo.git
git fetch baseline

# Resting our HEAD to golden repository
git checkout master
git reset --hard baseline/master

# Generating personal travis token
cp $DIR/templates/.travis.yml $DIR/..
travis encrypt TOKEN=$GITHUB_TOKEN --add  -e https://travisci.octodemoapps.com/api --debug
git commit -am "Adding my travis token after demo update"

# Disabling protected branches otherwise force push fails (when available in Enterprise)
# curl -H "Authorization: Token $GITHUB_TOKEN" -H "Accept: application/vnd.github.loki-preview+json" -H "Content-type: application/json" -X DELETE https://octodemo.com/api/v3/repos/$RT_ORG/$RT_REPO/branches/master/protection

# Updating master and our baseline to revert to later on
git push origin master:refs/tags/baseline -f
git push com master:refs/tags/baseline -f
git push origin master -f
git push com master -f

bash ./scripts/reset-demo.sh


