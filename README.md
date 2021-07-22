# ENE (ENE's Not Excel)

Webpage to serve UFSC's classes approval/failure rate from CSV files.

## Setup
1. Install elm by using the [official guide](https://guide.elm-lang.org/install.html).
2. Compile Elm with the time-travelling debugger by using
`elm-make Main.elm --output index.html --debug`
or use `elm-reactor` and visit `http://localhost:8000`

Due to external CSS i recommend using [`elm-live`](https://github.com/wking-io/elm-live) during development with the following input:
`elm-live src/Main.elm --start-page=index.html -- --output=main.js --debug`<br>
and `sass styles/main.scss styles/main.css --watch` if editing the CSS.

## Maintaining this website
1. Request data in CSV format from [e-SIC](https://esic.cgu.gov.br/) or email `dae@contato.ufsc.br`.
2. Run `convert.sh` in the obtained CSV files to convert them from `ISO-8859-1` to `UTF-8` (do not run twice on the same files, you can also use online tools for that).
3. Commit them to the `csv` folder.
4. If you are adding a new course, create a folder (`ene/csv/<course code>`) and update the `availableCourses` function in [`Data.elm`](https://github.com/caravelahc/ene/blob/99eb2ac861b53b3813ad58be8d3ac44701547a6f/src/Data.elm#L45).

## GitLab Deploy
This project uses GitLab CI to deploy to GitHub Pages, the following variables need to be set in the [CI configuration panel](https://gitlab.com/caravelahc/ene/-/settings/ci_cd).
Ensure that the pipelines are using `clone` as the git strategy instead of `fetch`.

Variable|Description
|-|-|
REMOTE_URL|Used to set the remote to be pushed inside the CI, must use this format: `https://<deploy-bot-name>:<deploy-account-access-token>@github.com/caravelahc/ene.git`
DEPLOY_USERNAME|GitHub username for the deploy commit.
DEPLOY_EMAIL|GitHub account email for the deploy commit

### Contributors
- [@matheusmk3](https://github.com/MatheusMK3) with the CSS files and styling.
- [@tarcisioe](https://github.com/tarcisioe/) with the `convert.sh` script.

### Qualidade dos dados
Os semestres EAD podem ter uma quantidade de reprovações maiores devido às mudanças ocasionadas pela pandemia. Alunos podem cancelar a disciplina a qualquer momento durante os semestres à distância e estes casos não estão incluídos nos CSVs. Os casos de reprovações de 100% da turma nos semestres EAD vêm da menção P que não está incluída no sistema do CAGR Desktop e portanto é reportada como nota zero.
