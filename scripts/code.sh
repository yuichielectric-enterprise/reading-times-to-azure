#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
git branch -D add-rating-feature
git checkout -b add-rating-feature
cp -rf $DIR/resources/main/java/* $DIR/../src/main/java/
git add src/main/java/
git commit -m "Added rating model and service"
cp -rf $DIR/resources/main/webapp/* $DIR/../src/main/webapp/
git add src/main/webapp/
git commit -m "Added rating view"
git push origin HEAD
