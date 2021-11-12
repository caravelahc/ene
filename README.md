# ENE (ENE's Not Excel)

Dados de aprovações e reprovações em disciplinas da UFSC.

## Setup
1. https://guide.elm-lang.org/install.html.
2. `elm-make Main.elm --output index.html --debug`
ou use `elm-reactor` e visite `http://localhost:8000`
3. Também pode ser utilizado o [`elm-live`](https://github.com/wking-io/elm-live):
`elm-live src/Main.elm --start-page=index.html -- --output=main.js --debug`<br>
com sass: `sass styles/main.scss styles/main.css --watch`

## Mantendo este site
1. Obtenha os dados de aprovações por curso através do [e-SIC](https://esic.cgu.gov.br/) ou pelo email `dae@contato.ufsc.br`.
2. Converta os arquivos de `ISO-8859-1` para `UTF-8`.
3. Faça um commit pra pasta `csv`.
4. Se for um novo curso crie uma nova pasta (`ene/csv/<codigo-do-curso>`) e atualize a função `availableCourses` function in [`Data.elm`](https://github.com/caravelahc/ene/blob/99eb2ac861b53b3813ad58be8d3ac44701547a6f/src/Data.elm#L45).

## GitLab Deploy
Esse projeto usa o GitLab CI para deploy, configure em [CI configuration panel](https://gitlab.com/caravelahc/ene/-/settings/ci_cd).
Use a estratégia `clone` ao invés de `fetch` na configuração do pipeline.

Variável|Descrição
|-|-|
REMOTE_URL|URL para o pipeline poder criar um commit no GH Pages: `https://<usuario-deploy>:<conta-deploy-token-de-acesso>@github.com/caravelahc/ene.git`
DEPLOY_USERNAME|Username para o commit de deploy.
DEPLOY_EMAIL|Email para o commit de deploy.

### Contribuidores
- [@matheusmk3](https://github.com/MatheusMK3): CSS.
- [@tarcisioe](https://github.com/tarcisioe/): `convert.sh`.

### Qualidade dos dados
Os semestres EAD podem ter uma quantidade de reprovações maiores devido às mudanças ocasionadas pela pandemia. Alunos podem cancelar a disciplina a qualquer momento durante os semestres à distância e estes casos não estão incluídos nos CSVs. Os casos de reprovações de 100% da turma nos semestres EAD vêm da menção P que não está incluída no sistema do CAGR Desktop e portanto é reportada como nota zero.
