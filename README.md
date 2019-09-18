# ENE (ENE's Not Excel)

A webpage to serve approval/failure rate and notes of UFSC's classes from CSV files.

## Setup
1. Install [Git LFS](https://github.com/git-lfs/git-lfs#getting-started).
2. Install elm by using the [official guide](https://guide.elm-lang.org/install.html).
3. Compile Elm using
`elm-make Main.elm --output index.html`
or use `elm-reactor` and visit `http://localhost:8000`

## Data
Data is obtained from a government website called [e-SIC](https://esic.cgu.gov.br/).

## GitLab Deploy
This project uses GitLab CI to deploy to GitHub Pages, the following variables need to be set in the [CI configuration panel](https://gitlab.com/caravelahc/ene/-/settings/ci_cd).
Ensure that the pipelines are using `clone` as the git strategy instead of `fetch`.

Variable|Description
|-|-|
REMOTE_URL|Used to set the remote to be pushed inside the CI, must use this format: `https://<deploy-bot-name>:<deploy-account-access-token>@github.com/caravelahc/ene.git`
DEPLOY_USERNAME|GitHub username for the deploy commit.
DEPLOY_EMAIL|GitHub account email for the deploy commit
