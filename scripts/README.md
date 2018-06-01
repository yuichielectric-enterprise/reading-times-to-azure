# Reading Time scripts

This folder contains several useful scripts. Please refer to the source code of each individual file to find out more about their usage.

## Requirements

For the scripts to work, you will need to create 3 additional accounts on Octodemo: one acting as the PM, one as UX and another for the designer, as described on [this page](https://github.com/github/solutions-engineering/blob/master/guides/onboarding/preparing-to-demo.md#demo-setup).
Once you've done that, you'll have to sign in on each of the accounts (including your own) and generate a [Personal Access Token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/#creating-a-token) with `repo` access for each user.

The following environment variables need to be exported for the scripts to work:

```
export GITHUB_TOKEN="..."
export RT_PM_TOKEN="..."
export RT_UX_TOKEN="..."
export RT_DS_TOKEN="..."
export RT_ORG="PizzaHub"
export RT_REPO="reading-time"
```

Also make sure you have `jq` installed for nicer output on the CLI (e.g. `brew install jq` on macOS).



