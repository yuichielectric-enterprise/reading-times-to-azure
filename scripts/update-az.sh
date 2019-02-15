#!/usr/bin/env bash

# Resting our HEAD to golden repository
git checkout master
git reset --hard baseline/master

# Updating master and our baseline to revert to later on
git push com master:refs/tags/baseline -f
git push com master -f

bash ./scripts/reset-az.sh


