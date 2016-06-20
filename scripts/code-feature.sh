#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
if [ $BRANCH == "master" ]
then
  echo "Your current branch is master, please first create a feature branch"
  echo "  For example: git checkout -b add-rating-feature"
  exit 1
else
  echo -e "Do you want to commit the code changes on branch '$BRANCH'?"
  echo -n "Press ENTER to continue"
  read
  cp -rf $DIR/resources/main/java/* $DIR/../src/main/java/
  git add src/main/java/
  git commit -m "Added rating model and service"
  cp -rf $DIR/resources/main/webapp/* $DIR/../src/main/webapp/
  git add src/main/webapp/
  echo "Adding commit "
  git commit -m "Added rating view"
  git push origin HEAD
fi

