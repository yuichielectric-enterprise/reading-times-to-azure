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
DEFAULT_FEATURE_BRANCH="add-rating-feature"

# Check if master branch is protected
BRANCHES_STATUS_CODE=$(curl -I -H "Authorization: Token $GITHUB_TOKEN" -H "Accept: application/json" https://octodemo.com/api/v3/repos/$RT_ORG/$RT_REPO/branches/master/protection -s -o /dev/null -w %{http_code})

if [ $BRANCHES_STATUS_CODE -ne "404" ] ; then

    echo "Master is protected: disabling protection"

    # Read required status currently activated on master branch
    CONTEXTS=$(curl -H "Authorization: Token $GITHUB_TOKEN" -H "Accept: application/json" https://octodemo.com/api/v3/repos/$RT_ORG/$RT_REPO/branches/master/protection/required_status_checks/contexts)

    # Remove new lines from $CONTEXTS
    CONTEXTS=$(echo $CONTEXTS|tr -d '\n')

    # Disabling protected branches otherwise force push fails (when available in Enterprise)
    curl -H "Authorization: Token $GITHUB_TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X DELETE https://octodemo.com/api/v3/repos/$RT_ORG/$RT_REPO/branches/master/protection

else
  echo "Master is not protected"
fi

# Force push HEAD to baseline
echo "Reverting master to baseline tag"
git fetch --tags
git checkout master
git reset --hard baseline
git push origin baseline:master -f
git push com baseline:master -f

if [ "$BRANCHES_STATUS_CODE" -ne 404 ] ; then

    echo "Re-enabling protected branches as before: $CONTEXTS"

    # Get the new JSON based on the protected.json template and run the re-enable API
    sed -e "s|CONTEXTS_PLACEHOLDER|$CONTEXTS|g" scripts/protected.json | curl -H "Authorization: Token $GITHUB_TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X PUT https://octodemo.com/api/v3/repos/$RT_ORG/$RT_REPO/branches/master/protection -d @-
fi



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

ISSUE_NUMBER=`curl -H "Authorization: Token $RT_PM_TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d @$DIR/issues/message1.json https://octodemo.com/api/v3/repos/$RT_ORG/$RT_REPO/issues | jq .number`

ECHO "Issue created. Number=$ISSUE_NUMBER"

curl -H "Authorization: Token $RT_UX_TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d @$DIR/issues/message2.json https://octodemo.com/api/v3/repos/$RT_ORG/$RT_REPO/issues/$ISSUE_NUMBER/comments
curl -H "Authorization: Token $RT_PM_TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d @$DIR/issues/message3.json https://octodemo.com/api/v3/repos/$RT_ORG/$RT_REPO/issues/$ISSUE_NUMBER/comments
curl -H "Authorization: Token $RT_DS_TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d @$DIR/issues/message4.json https://octodemo.com/api/v3/repos/$RT_ORG/$RT_REPO/issues/$ISSUE_NUMBER/comments

read -p  "Do you want to delete the feature branch locally  (y/N)?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  
  read -p  "What's the name of the branch [$DEFAULT_FEATURE_BRANCH]?" -r
  echo
  if [[ $REPLY == '' ]]
  then
    TARGET_BRANCH="$DEFAULT_FEATURE_BRANCH"
  else 
    TARGET_BRANCH="$REPLY"
  fi
  git branch -D $TARGET_BRANCH
fi

read -p  "Do you want to delete the feature branch on $RT_ORG/$RT_REPO  (y/N)?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  read -p  "What's the name of the branch [$DEFAULT_FEATURE_BRANCH]?" -r
  echo
  if [[ $REPLY == '' ]]
  then
    TARGET_BRANCH="$DEFAULT_FEATURE_BRANCH"
  else 
    TARGET_BRANCH="$REPLY"
  fi
  git push origin --delete $TARGET_BRANCH
fi

echo "Redeploying master to heroku"
git push heroku master -f
