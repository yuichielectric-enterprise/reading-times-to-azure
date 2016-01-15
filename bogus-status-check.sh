#!/usr/bin/env bash
echo "Travis Commit: $TRAVIS_COMMIT"
echo "Travis Pull Request Number: $TRAVIS_PULL_REQUEST"
echo "Home directory: $HOME"

curl -H "Authorization: Token $TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"state": "pending","target_url": "https://travis.octodemo.com/'$TRAVIS_REPO_SLUG'","description": "Executing bogus status check","context": "bogus-status-check/travis-ci"}' https://octodemo.com/api/v3/repos/${TRAVIS_REPO_SLUG}/statuses/$TRAVIS_COMMIT

mvn test -DskipTests=true
STATE="success"
STATUS=$?
if [ $STATUS -eq 0 ]; then
  state="success"
else
  state="failure"
fi

curl -H "Authorization: Token $TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"state": "'"$STATE"'","target_url": "https://travis.octodemo.com/'$TRAVIS_REPO_SLUG'","description": "Executing bogus status check","context": "bogus-status-check/travis-ci"}' https://octodemo.com/api/v3/repos/${TRAVIS_REPO_SLUG}/statuses/$TRAVIS_COMMIT
