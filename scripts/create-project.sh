# Creates a Project board with 3 columns to simulate an ongoing sprint
# TODO: create a number of Cards to simulate real action

# TODO: Change back to "application/json" once API is stable. 
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


echo "Creating new Project."
PROJECT_ID=`curl -s -H "Authorization: Token $GITHUB_TOKEN" -H "Accept: $ACCEPT_HEADER" -H "Content-type: application/json" -X POST -d @$DIR/projects/project1.json https://octodemo.com/api/v3/repos/$RT_ORG/$RT_REPO/projects | jq .id`
echo "📊 Project created with id: $PROJECT_ID"

echo "Creating Columns"
TODO_COL_ID=`curl -s -H "Authorization: Token $GITHUB_TOKEN" -H "Accept: $ACCEPT_HEADER" -H "Content-type: application/json" -X POST -d @$DIR/projects/column1.json https://octodemo.com/api/v3/projects/$PROJECT_ID/columns | jq .id`
echo "[1/3] ✅ TODO column created. id=$TODO_COL_ID"

PROG_COL_ID=`curl -s -H "Authorization: Token $GITHUB_TOKEN" -H "Accept: $ACCEPT_HEADER" -H "Content-type: application/json" -X POST -d @$DIR/projects/column2.json https://octodemo.com/api/v3/projects/$PROJECT_ID/columns | jq .id`
echo "[2/3] ✅ In Progress column created. id=$PROG_COL_ID"

DONE_COL_ID=`curl -s -H "Authorization: Token $GITHUB_TOKEN" -H "Accept: $ACCEPT_HEADER" -H "Content-type: application/json" -X POST -d @$DIR/projects/column3.json https://octodemo.com/api/v3/projects/$PROJECT_ID/columns | jq .id`
echo "[3/3] ✅ Done column created. id=$DONE_COL_ID"
