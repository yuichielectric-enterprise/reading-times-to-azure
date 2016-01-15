#!/usr/bin/env bash
echo "Travis Commit: $TRAVIS_COMMIT"

function statuses () {
  curl -H "Authorization: Token $TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"state": "'"$1"'","target_url": "https://octodemo.com/pages/'$TRAVIS_REPO_SLUG'","description": "'"$2"'","context": "site-status-check/travis-ci"}' https://octodemo.com/api/v3/repos/${TRAVIS_REPO_SLUG}/statuses/$TRAVIS_COMMIT
}

statuses "pending" "Generating Maven project site"

mvn clean site
STATUS=$?
echo "$STATUS"
if [ $STATUS -eq 0 ]; then
  statuses "success" "Maven project site succesfully created"
else
  statuses "failure" "Unable to create Maven project site"
fi
