function statuses () {
  curl -s -H "Authorization: Token $GITHUB_TOKEN" -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"state": "'"$1"'","target_url": "https://reading-time-app.herokuapp.com/","description": "'"$2"'"}' https://octodemo.com/api/v3/repos/office-tools/reading-time-app/deployments/$deployment_id/statuses
}

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

statuses "pending" "Pending deployment to test"

sleep 10

statuses "success" "Successful deployment to test"
