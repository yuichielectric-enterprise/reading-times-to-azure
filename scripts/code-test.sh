#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
if [ $BRANCH == "master" ]
then
  echo "Your current branch is master, please checkout the feature branch"
  echo "  For example: git checkout add-rating-feature"
  exit 1
else
  read -p  "Do you want to commit the code changes on branch '$BRANCH' (y/N)?" -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    cp -rf $DIR/resources/test/java/* $DIR/../src/test/java/
    git add src/test/java/
    git commit -m "Added unit tests for rating model"
    git push origin HEAD
  fi
fi
