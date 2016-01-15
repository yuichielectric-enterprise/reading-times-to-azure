#!/usr/bin/env bash
echo "Travis Commit: $TRAVIS_COMMIT"
echo "Travis Pull Request Number: $TRAVIS_PULL_REQUEST"
echo "Home directory: $HOME"

function statuses () {
  curl -H "Authorization: Token $TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"state": "'"$STATE"'","target_url": "https://travis.octodemo.com/'$TRAVIS_REPO_SLUG'","description": "Executing mvn verify with checkstyle","context": "checkstyle-status-check/travis-ci"}' https://octodemo.com/api/v3/repos/${TRAVIS_REPO_SLUG}/statuses/$TRAVIS_COMMIT
}

STATE="pending"

statuses

mvn verify -DskipTests=true
STATUS=$?
echo "$STATUS"
if [ $STATUS -eq 0 ]; then
  STATE="success"
else
  STATE="failure"
fi

statuses
