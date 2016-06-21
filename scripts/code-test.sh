#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
if [ $BRANCH == "master" ]
then
  echo "Your current branch is master, please checkout the feature branch"
  echo "  For example: git checkout add-rating-feature"
  exit 1
else
  cp -rf $DIR/resources/test/* $DIR/../src/test/
  read -p  "Do you want to commit the code changes on branch '$BRANCH' (y/N)?" -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    git add src/test/java/
    git commit -m "Added unit tests for rating model"
    read -p  "Do you want to push the code changes on branch '$BRANCH' (y/N)?" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      git push origin HEAD
    fi
  fi
fi
