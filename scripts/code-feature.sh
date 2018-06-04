#!/usr/bin/env bash
# This script:
# - optionally creates a feature branch if ran on master
# - optionally commits the feature code changes
# - optionally pushes the commits to the same branch upstream

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
if [ $BRANCH == "master" ]
then
  echo "Your current branch is master, please first create a feature branch"
  echo "  For example: git checkout -b add-rating-feature"
  read -p  "Do you want me to create that for you (y/N)?" -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    git checkout -b add-rating-feature
  else 
    exit 1
  fi
fi
cp -rf $DIR/resources/main/* $DIR/../src/main/
read -p  "Do you want to commit the code changes on branch '$BRANCH' (y/N)?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  git add src/main/java/
  git commit -m "Added rating model and service"
  git add src/main/webapp/
  git commit -m "Added rating view"
  read -p  "Do you want to push the code changes on branch '$BRANCH' (y/N)?" -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    git push origin HEAD
  fi
fi
