echo "Travis Commit: $TRAVIS_COMMIT"
echo "Travis Branch: $TRAVIS_BRANCH"
echo "Travis repo: $TRAVIS_REPO_SLUG"

deployment_id=$(curl -s -H "Authorization: Token $TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"ref": "'"$TRAVIS_PULL_REQUEST"'","description": "Deploying branch to neverland", "environment": "development"}' https://octodemo.com/api/v3/repos/office-tools/reading-time-app/deployments | jq '.id')

echo "Deployment ID: $deployment_id"

curl -H "Authorization: Token $TOKEN" -s -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"state": "pending","target_url": "https://travis.octodemo.com/office-tools/reading-time-app","description": "Pending deployment to neverland"}' https://octodemo.com/api/v3/repos/office-tools/reading-time-app/deployments/$deployment_id/statuses

sleep 10

curl -H "Authorization: Token $TOKEN" -s -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"state": "success","target_url": "https://travis.octodemo.com/office-tools/reading-time-app","description": "Successful deployment to neverland"}' https://octodemo.com/api/v3/repos/office-tools/reading-time-app/deployments/$deployment_id/statuses
