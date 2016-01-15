#!/usr/bin/env bash
echo "Travis Commit: $TRAVIS_COMMIT"

function statuses () {
  curl -H "Authorization: Token $TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"state": "'"$1"'","target_url": "https://travis.octodemo.com/'$TRAVIS_REPO_SLUG'","description": "'"$2"'","context": "checkstyle-status-check/travis-ci"}' https://octodemo.com/api/v3/repos/${TRAVIS_REPO_SLUG}/statuses/$TRAVIS_COMMIT
}

statuses "pending" "Checking Java code against coding standards"

mvn verify -DskipTests=true
STATUS=$?
echo "$STATUS"
if [ $STATUS -eq 0 ]; then
  statuses "success" "Java code meets coding standards"
else
  statuses "failure" "Java code does not meeting coding standards"
fi
