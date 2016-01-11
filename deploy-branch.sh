: ${GITHUB_TOKEN?"Please set environment variable GITHUB_TOKEN to the GitHub access token"}

echo -e "Hi, please type the name of the branch: \c "
read  branch
echo "Will create deployment for $branch"

deployment_id=$(curl -s -H "Authorization: Token $GITHUB_TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"ref": "'"$branch"'","description": "Deploying branch to neverland", "environment": "test"}' https://octodemo.com/api/v3/repos/office-tools/reading-time-app/deployments | jq '.id')

echo "Deployment ID: $deployment_id"

if (($deployment_id == null))
then
  echo "Create deployment failed, please check the branch name: ${branch}"
  exit 1
fi

curl -s -H "Authorization: Token $GITHUB_TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"state": "pending","target_url": "https://travis.octodemo.com/office-tools/reading-time-app","description": "Pending deployment to neverland"}' https://octodemo.com/api/v3/repos/office-tools/reading-time-app/deployments/$deployment_id/statuses

sleep 10

curl -s -H "Authorization: Token $GITHUB_TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"state": "success","target_url": "https://travis.octodemo.com/office-tools/reading-time-app","description": "Successful deployment to neverland"}' https://octodemo.com/api/v3/repos/office-tools/reading-time-app/deployments/$deployment_id/statuses
