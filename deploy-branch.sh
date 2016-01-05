echo "Travis Commit: $TRAVIS_COMMIT"
echo "Travis Branch: $TRAVIS_BRANCH"
echo "Travis repo: $TRAVIS_REPO_SLUG"

BRANCH="bas-patch-2"

echo "Branch: $BRANCH"

deployment_id=$(curl -s -H "Authorization: Token $TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"ref": "'"$BRANCH"'","description": "Deploying branch to neverland", "environment": "test"}' https://octodemo.com/api/v3/repos/office-tools/reading-time-app/deployments | jq '.id')

echo "Deployment ID: $deployment_id"

curl -s -H "Authorization: Token $TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"state": "pending","target_url": "https://travis.octodemo.com/office-tools/reading-time-app","description": "Pending deployment to neverland"}' https://octodemo.com/api/v3/repos/office-tools/reading-time-app/deployments/$deployment_id/statuses

sleep 10

curl -s -H "Authorization: Token $TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"state": "success","target_url": "https://travis.octodemo.com/office-tools/reading-time-app","description": "Successful deployment to neverland"}' https://octodemo.com/api/v3/repos/office-tools/reading-time-app/deployments/$deployment_id/statuses
