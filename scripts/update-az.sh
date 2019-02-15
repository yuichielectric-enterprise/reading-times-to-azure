#!/usr/bin/env bash

# Getting the original content
git remote add baseline git@octodemo.com:baseline/reading-time-demo.git
git fetch baseline

# Resting our HEAD to golden repository
git checkout master
git reset --hard baseline/master

# Updating master and our baseline to revert to later on
git tag baseline -f
git push com baseline -f
git push com master -f

bash ./scripts/reset-az.sh
