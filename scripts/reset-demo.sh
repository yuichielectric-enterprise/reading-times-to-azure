# This script reset the demo for a reading-time-app (RT) project
# Required environment variables
# RT_PM_TOKEN for the PM actor
# RT_UX_TOKEN for the UX actor
# RT_DS_TOKEN for the Designer actor
# RT_ORG organization that holds the reading-time repository
# RT_REPO reading time repository name

# It would be awesome if the bellow used like arrays and data structures, but then again this is bash :(

#!/usr/bin/bash
echo "Re-setting Demo"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Reverting master to baseline tag"
git fetch --tags
git checkout master
git reset --hard baseline
git push origin baseline:master -f


function close_issue () {
  curl -H "Authorization: Token $GITHUB_TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X PATCH -d '{"state": "closed"}' https://octodemo.com/api/v3/repos/$RT_ORG/$RT_REPO/issues/$1
}

echo "Closing existing issues"

for issue_number in $(curl -s -H "Authorization: Token $GITHUB_TOKEN" -H "Accept: application/json" "https://octodemo.com/api/v3/search/issues?q=state:open+repo:$RT_ORG/$RT_REPO+type:issue&sort=created&order=asc" | jq -r '.items[].number')
do
  echo "Closing issue with number: $issue_number"
  close_issue $issue_number
done


echo "Opening template issue"

BODY1=`cat $DIR/issues/message1.md`
echo $BODY1

ISSUE_NUMBER=`curl -H "Authorization: Token $RT_PM_TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d @$DIR/issues/message1.json https://octodemo.com/api/v3/repos/$RT_ORG/$RT_REPO/issues | jq .number`

ECHO "Issue created. Number=$ISSUE_NUMBER"

curl -H "Authorization: Token $RT_UX_TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d @$DIR/issues/message2.json https://octodemo.com/api/v3/repos/$RT_ORG/$RT_REPO/issues/$ISSUE_NUMBER/comments
curl -H "Authorization: Token $RT_PM_TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d @$DIR/issues/message3.json https://octodemo.com/api/v3/repos/$RT_ORG/$RT_REPO/issues/$ISSUE_NUMBER/comments
curl -H "Authorization: Token $RT_DS_TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d @$DIR/issues/message4.json https://octodemo.com/api/v3/repos/$RT_ORG/$RT_REPO/issues/$ISSUE_NUMBER/comments


echo "Redeploying master to heroku"
git push heroku master -f