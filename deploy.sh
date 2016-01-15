ref=$(curl -s -H "Authorization: Token $TOKEN" -H "Accept: application/json" https://octodemo.com/api/v3/repos/${TRAVIS_REPO_SLUG}/pulls/${TRAVIS_PULL_REQUEST} | jq '.head.ref')

echo "Pull Request: $ref"

deployment_id=$(curl -s -H "Authorization: Token $TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"ref": '${ref}',"description": "Deploying branch to test", "environment": "test"}' https://octodemo.com/api/v3/repos/${TRAVIS_REPO_SLUG}/deployments | jq '.id')

echo "Deployment ID: $deployment_id"

if (($deployment_id == null))
then
  echo "Create deployment failed, please check the branch name: ${ref}"
  exit 1
fi

curl -s -H "Authorization: Token $TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"state": "pending","target_url": "https://reading-time-app.herokuapp.com/","description": "Pending deployment to test"}' https://octodemo.com/api/v3/repos/${TRAVIS_REPO_SLUG}/deployments/$deployment_id/statuses

sleep 10

curl -s -H "Authorization: Token $TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"state": "success","target_url": "https://reading-time-app.herokuapp.com/","description": "Successful deployment to test"}' https://octodemo.com/api/v3/repos/${TRAVIS_REPO_SLUG}/deployments/$deployment_id/statuses
