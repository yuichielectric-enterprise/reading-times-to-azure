echo "Repository: $TRAVIS_REPO_SLUG"
echo "Token: $TOKEN"
echo "PR: $TRAVIS_PULL_REQUEST"

function statuses () {
  curl -s -H "Authorization: Token $TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"state": "'"$1"'","target_url": "https://reading-time-app.herokuapp.com/","description": "'"$2"'"}' https://octodemo.com/api/v3/repos/${TRAVIS_REPO_SLUG}/deployments/$deployment_id/statuses
}

ref=$(curl -s -H "Authorization: Token $TOKEN" -H "Accept: application/json" https://octodemo.com/api/v3/repos/${TRAVIS_REPO_SLUG}/pulls/${TRAVIS_PULL_REQUEST} | jq '.head.ref')

echo "Pull Request: $ref"

deployment_id=$(curl -s -H "Authorization: Token $TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"ref": '${ref}',"description": "Deploying branch to test", "environment": "test"}' https://octodemo.com/api/v3/repos/${TRAVIS_REPO_SLUG}/deployments | jq '.id')

echo "Deployment ID: $deployment_id"

if (($deployment_id == null))
then
  echo "Create deployment failed, please check the branch name: ${ref}"
  exit 1
fi

#statuses "pending" "Pending deployment to test"

#sleep 10

#statuses "success" "Successfully deployment to test"
