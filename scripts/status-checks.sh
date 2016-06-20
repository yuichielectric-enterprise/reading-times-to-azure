#!/usr/bin/env bash
echo "Travis Commit: $TRAVIS_COMMIT"

function statuses () {
  curl -H "Authorization: Token $TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"state": "'"$1"'","target_url": "https://travis.octodemo.com/'$TRAVIS_REPO_SLUG'","description": "'"$2"'","context": "'$3'-status-check/travis-ci"}' https://octodemo.com/api/v3/repos/${TRAVIS_REPO_SLUG}/statuses/$TRAVIS_COMMIT
}

if [ "$1" = "verify" ]; then
  statuses "pending" "Checking Java code against coding standards" "$1"
  mvn verify -DskipTests=true
  STATUS=$?
  echo "$STATUS"
  if [ $STATUS -eq 0 ]; then
    statuses "success" "Java code meets coding standards" "$1"
  else
    statuses "failure" "Java code doesn't meet coding standards" "$1"
    exit 1
  fi
elif [ "$1" = "install" ]; then
  statuses "pending" "Running build" "$1"
  mvn install -DskipTests=true -Dcheckstyle.skip=true -Dmaven.javadoc.skip=true -B -V
  STATUS=$?
  echo "$STATUS"
  if [ $STATUS -eq 0 ]; then
    statuses "success" "Build succesful" "$1"
  else
    statuses "failure" "Build failed" "$1"
    exit 1
  fi
elif [ "$1" = "test" ]; then
  statuses "pending" "Running tests" "$1"
  mvn test -B -Dcheckstyle.skip=true
  STATUS=$?
  echo "$STATUS"
  if [ $STATUS -eq 0 ]; then
    statuses "success" "All tests passed" "$1"
  else
    statuses "failure" "One or more tests failed" "$1"
    exit 1
  fi
elif [ "$1" = "coverage" ]; then
  statuses "pending" "Running coverage check" "$1"
  mvn clean site
  STATUS=$?
  echo "$STATUS"
  if [ $STATUS -eq 0 ]; then
    statuses "success" "Coverage check passed" "$1"
  else
    statuses "failure" "Coverage check failed" "$1"
    exit 1
  fi
elif [ "$1" = "site" ]; then
  statuses "pending" "Generating Maven project site" "$1"
  mvn clean site
  STATUS=$?
  echo "$STATUS"
  if [ $STATUS -eq 0 ]; then
    statuses "success" "Maven project site succesfully created" "$1"
  else
    statuses "failure" "Unable to create Maven project site" "$1"
  fi
fi
