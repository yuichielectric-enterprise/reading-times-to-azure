echo "Travis Commit: $TRAVIS_COMMIT"
echo "Token: $TOKEN"

curl -u bas:$TOKEN -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"state": "pending","target_url": "https://travis.octodemo.com/office-tools/reading-time-app","description": "Executing PR comment check","context": "pr-check/travis"}' https://octodemo.com/api/v3/repos/office-tools/reading-time-app/statuses/$TRAVIS_COMMIT

echo "$TRAVIS_PULL_REQUEST"

result=$(curl -u bas:$TOKEN -H "Accept: application/json" -H "Content-type: application/json"  https://octodemo.com/api/v3/repos/office-tools/reading-time-app/pulls/$TRAVIS_PULL_REQUEST | jq '.body')

count=${#result}

echo "$count"

if [ $count -lt 50 ]
then
  echo "Please add a PR comment of at least 50 characters"
  CSTATUS="failure"
else
  echo "Good work! Your PR comment has context!"
  CSTATUS="success"
fi

echo "PR Code Status: $CSTATUS"

curl -u bas:$TOKEN -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"state": "success","target_url": "https://travis.octodemo.com/office-tools/reading-time-app","description": "Executing PR comment check","context": "pr-check/travis"}' https://octodemo.com/api/v3/repos/office-tools/reading-time-app/statuses/$TRAVIS_COMMIT
