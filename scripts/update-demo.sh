#!/usr/bin/env bash
git remote add office-tools git@octodemo.com:office-tools/reading-time-app.git
git fetch office-tools
git checkout master
git reset --hard office-tools/master
git push origin master:baseline -f

bash ./scripts/reset-demo.sh
