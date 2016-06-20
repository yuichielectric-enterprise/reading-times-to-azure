#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cp -rf $DIR/resources/test/java/* $DIR/../src/test/java/
git add src/test/java/
git commit -m "Added unit tests for rating model"
#git push origin HEAD