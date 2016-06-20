# This script reset the demo for a reading-time-app (RT) project
# Required environment variables
# RT_PM_TOKEN for the PM actor
# RT_UX_TOKEN for the UX actor
# RT_DS_TOKEN for the Designer actor
# RT_ORG organization that holds the reading-time repository
# RT_REPO reading time repository name

# It would be awesome if the bellow used like arrays and data structures, but then again this is bash :(

#!/usr/bin/bash
echo "Resetting Demo"

ISSUE_NUMBER=`curl -H "Authorization: Token $RT_PM_TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"title": "Adding a rating feature to the book store","body": "Body 1"}' https://octodemo.com/api/v3/repos/$RT_ORG/$RT_REPO/issues | jq .number`

ECHO "Issue created. Number=$ISSUE_NUMBER"

curl -H "Authorization: Token $RT_UX_TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"body": "Body 2"}' https://octodemo.com/api/v3/repos/$RT_ORG/$RT_REPO/issues/$ISSUE_NUMBER/comments
curl -H "Authorization: Token $RT_PM_TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"body": "Body 3"}' https://octodemo.com/api/v3/repos/$RT_ORG/$RT_REPO/issues/$ISSUE_NUMBER/comments
curl -H "Authorization: Token $RT_DS_TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"body": "Body 4"}' https://octodemo.com/api/v3/repos/$RT_ORG/$RT_REPO/issues/$ISSUE_NUMBER/comments

