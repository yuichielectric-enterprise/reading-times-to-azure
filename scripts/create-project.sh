# Creates a Project board with a bunch of Cards to simulate an ongoing sprint

# TODO: Change back to application/json once API is stable. 
# See: https://developer.github.com/v3/projects/#create-a-repository-project
ACCEPT_HEADER="application/vnd.github.inertia-preview+json"  

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function delete_project () {
  curl -H "Authorization: Token $GITHUB_TOKEN" -H "Accept: $ACCEPT_HEADER" -H "Content-type: application/json" -X DELETE https://octodemo.com/api/v3/projects/$1
}

read -p  "Do you want to delete your existing Projects on '$RT_ORG/$RT_REPO' (y/N)?" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    for project_id in $(curl -s -H "Authorization: Token $GITHUB_TOKEN" -H "Accept: $ACCEPT_HEADER" "https://octodemo.com/api/v3/repos/$RT_ORG/$RT_REPO/projects" | jq -r '.[].id')
    do
        echo "☠️  Deleting project with id: $project_id"
        delete_project $project_id
    done
fi


echo "Creating Project"
PROJECT_NUMBER=`curl -H "Authorization: Token $GITHUB_TOKEN" -H "Accept: $ACCEPT_HEADER" -H "Content-type: application/json" -X POST -d @$DIR/projects/project1.json https://octodemo.com/api/v3/repos/$RT_ORG/$RT_REPO/projects | jq .number`
ECHO "Project created. Number=$PROJECT_NUMBER"

### BUMMER! We can't use the `/projects` endpoint just yet on GHE... stopping here for now!
echo "Creating Columns"
curl -H "Authorization: Token $GITHUB_TOKEN" -H "Accept: $ACCEPT_HEADER" -H "Content-type: application/json" -X POST -d @$DIR/projects/column1.json https://octodemo.com/api/v3/projects/$PROJECT_NUMBER
# ECHO "TODO column created. Number=$TODO_ID"

