# Guia de Setup do Kiro — Configuracao Completa (Admin)

Copie e cole este guia em qualquer sessao do Kiro para replicar toda a configuracao.

---

## PRE-REQUISITOS — Antes de comecar

Garanta que os itens abaixo estao instalados e funcionando antes de executar qualquer passo.

### 1. Kiro IDE
Baixe e instale o Kiro em: https://kiro.dev

### 2. Git
Necessario para clonar o repositorio de configuracao e para o sync automatico.

- Download: https://git-scm.com/download/win
- Apos instalar, verifique: `git --version`
- Configure sua identidade (obrigatorio para commits):
  ```bash
  git config --global user.email "seu-email@exemplo.com"
  git config --global user.name "Seu Nome"
  ```
- Configure o armazenamento de credenciais para nao precisar digitar senha toda vez:
  ```bash
  git config --global credential.helper manager
  ```

> Se `git` nao for reconhecido no terminal apos a instalacao, adicione `C:\Program Files\Git\bin` ao PATH do sistema e reinicie o terminal.

### 3. Node.js
Necessario para os MCPs que usam `npx` (drawio-aws, drawio-official, aws-pricing-calculator).

- Download (versao LTS): https://nodejs.org
- Apos instalar, verifique:
  ```bash
  node -v
  npm -v
  ```

### 4. uv (para MCPs com uvx)
Necessario para os MCPs que usam `uvx` (filesystem, git, fetch, brave-search, aws-docs, etc.).

Instale via PowerShell (nao precisa de Python):
```powershell
powershell -ExecutionPolicy Bypass -Command "irm https://astral.sh/uv/install.ps1 | iex"
```

O instalador coloca o `uvx.exe` em `C:\Users\<seu-usuario>\.local\bin\`.

- Verifique (em um terminal novo):
  ```bash
  C:\Users\<seu-usuario>\.local\bin\uvx.exe --version
  ```

> Use sempre o **caminho completo** do uvx no mcp.json — o Kiro pode nao enxergar o PATH do usuario.

### 5. Conta GitHub com Personal Access Token
Necessario para clonar o repositorio (privado) e para o sync automatico via push.

- Crie um token em: https://github.com/settings/tokens/new
- Escopos necessarios: `repo` (acesso completo a repositorios)
- Guarde o token — ele sera usado como senha ao clonar e no push automatico

### Checklist rapido

| Item | Comando de verificacao | Status esperado |
|------|------------------------|-----------------|
| Git | `git --version` | `git version 2.x.x` |
| Node.js | `node -v` | `v20.x.x` ou superior |
| npm | `npm -v` | `10.x.x` ou superior |
| Python | `python --version` | `3.10` ou superior |
| uv/uvx | `C:\Users\<seu-usuario>\.local\bin\uvx.exe --version` | `uv x.x.x` |

> Todos os comandos acima devem funcionar em um terminal novo antes de prosseguir.

---

## PASSO 1 — Clonar o repositorio de configuracao

O repositorio deve ser clonado em uma pasta temporaria — **nao diretamente no `.kiro`**, pois o Kiro ja cria essa pasta com arquivos proprios ao ser instalado.

```bash
git clone https://github.com/isaiasgonzaga/kiro-config.git "C:\kiro-config-clone"
```

---

## PASSO 2 — Copiar as configuracoes para o Kiro

Copie os arquivos do clone para o diretorio do Kiro:

```bash
:: Criar pasta settings se nao existir
mkdir "C:\Users\<seu-usuario>\.kiro\settings"

:: mcp.json (template base — voce vai preencher as keys no proximo passo)
copy "C:\kiro-config-clone\settings\mcp.template.json" "C:\Users\<seu-usuario>\.kiro\settings\mcp.json"

:: Steering files (regras e comportamentos do agente)
copy "C:\kiro-config-clone\steering\language.md" "C:\Users\<seu-usuario>\.kiro\steering\language.md"
copy "C:\kiro-config-clone\steering\aws-calculator.md" "C:\Users\<seu-usuario>\.kiro\steering\aws-calculator.md"
copy "C:\kiro-config-clone\steering\aws-diagrams.md" "C:\Users\<seu-usuario>\.kiro\steering\aws-diagrams.md"

:: Extensions e Powers
copy "C:\kiro-config-clone\extensions\extensions.json" "C:\Users\<seu-usuario>\.kiro\extensions\extensions.json"
copy "C:\kiro-config-clone\powers\installed.json" "C:\Users\<seu-usuario>\.kiro\powers\installed.json"
```

O que cada arquivo contem:

| Arquivo | Conteudo |
|---------|----------|
| `steering/language.md` | Kiro responde em portugues brasileiro |
| `steering/aws-calculator.md` | Fluxo guiado para estimativas AWS |
| `steering/aws-diagrams.md` | Padrao de diagramas AWS |
| `extensions/extensions.json` | Extensoes recomendadas |
| `powers/installed.json` | Powers configurados |
| `settings/mcp.json` | Configuracao dos MCPs (nao vai para o git) |

---

## PASSO 3 — Configurar o mcp.json com suas API keys

Abra o arquivo `C:\Users\<seu-usuario>\.kiro\settings\mcp.json` e substitua os placeholders:

- `<seu-usuario>` em todos os caminhos de `uvx.exe` -> seu nome de usuario do Windows (ex: `joao.silva`)
- `GITHUB_TOKEN` -> seu Personal Access Token do GitHub
- `BRAVE_API_KEY` -> sua API key do Brave Search
- `DATABASE_URL` -> sua string de conexao do banco
- `SLACK_BOT_TOKEN` / `SLACK_TEAM_ID` -> credenciais do Slack

Para habilitar um servidor, mude `"disabled": true` para `"disabled": false`.

> O mcp.json ja usa caminhos completos para `npx.cmd` e `uvx.exe` para garantir que os MCPs funcionem mesmo quando o PATH do sistema nao inclui nodejs ou uv.

---

## PASSO 4 — MCPs ja configurados e ativos

Os seguintes MCPs ja estao ativos (`"disabled": false`) no template:

| MCP | Comando | O que faz |
|-----|---------|-----------|
| `drawio-aws` | `npx -y https://github.com/aws-samples/sample-drawio-mcp/...` | Diagramas AWS via Draw.io |
| `drawio-official` | `npx -y @drawio/mcp` | MCP oficial do Draw.io (XML, CSV, Mermaid) |
| `aws-pricing-calculator` | `npx -y sample-aws-pricing-calculator-mcp@latest` | Calculadora AWS via linguagem natural |

Os seguintes MCPs estao disponiveis mas **desativados** (precisam de API key):

| MCP | Ativar quando |
|-----|---------------|
| `filesystem` | Precisar dar acesso a arquivos locais |
| `git` | Quiser operacoes Git via agente |
| `fetch` | Quiser buscar conteudo web |
| `brave-search` | Tiver uma Brave API key |
| `aws-docs` | Quiser documentacao AWS inline |
| `postgres` | Tiver banco PostgreSQL local |
| `github` | Quiser operacoes no GitHub via agente |
| `slack` | Tiver um workspace Slack |

---

## PASSO 5 — Inicializar o Git no diretorio do Kiro

O sync automatico requer que o diretorio `~\.kiro` seja um repositorio Git conectado ao remote.

```bash
cd "C:\Users\<seu-usuario>\.kiro"

:: Inicializar o repositorio
git init

:: Conectar ao remote
git remote add origin https://github.com/<seu-usuario>/kiro-config.git

:: Baixar o historico e configurar o tracking
git fetch origin master
git update-ref refs/heads/master origin/master
git symbolic-ref HEAD refs/heads/master
git branch --set-upstream-to=origin/master master
git reset HEAD
```

> Este processo conecta o `.kiro` ao repositorio remoto sem sobrescrever os arquivos existentes.

### Criar o .gitignore

Crie o arquivo `C:\Users\<seu-usuario>\.kiro\.gitignore` com o seguinte conteudo:

```
# Secrets e tokens - NAO versionar
settings/mcp.json

# Pasta interna de hooks do Kiro (local apenas)
.kiro/

# Logs e sessoes (locais, nao versionar)
logs/
sessions/
skills/
powers/registries/

# Arquivos de estado interno
.trust-migration.json
argv.json
```

> Este `.gitignore` garante que apenas `steering/`, `extensions/`, `powers/installed.json` e `settings/mcp.template.json` sejam versionados. Logs, sessoes e o `mcp.json` com suas keys ficam apenas na sua maquina.

---

## PASSO 6 — Configurar o sync automatico

O sync commita e faz push automaticamente das suas steering files e configuracoes apos cada sessao do Kiro.

### 6.1 — Criar o script de sync

```bash
mkdir C:\kiro-sync
```

Crie o arquivo `C:\kiro-sync\sync.bat` com o seguinte conteudo:

```bat
@echo off
cd /d "C:\Users\<seu-usuario>\.kiro"
"C:\Program Files\Git\bin\git.exe" add .
"C:\Program Files\Git\bin\git.exe" diff --cached --quiet
if errorlevel 1 (
    "C:\Program Files\Git\bin\git.exe" commit -m "sync: atualizacao automatica de configs"
    "C:\Program Files\Git\bin\git.exe" push
)
```

> Use o caminho completo do git (`C:\Program Files\Git\bin\git.exe`) para garantir que o script funcione mesmo quando o git nao esta no PATH do sistema.
> O script precisa estar em `C:\kiro-sync\` — caminho SEM ESPACOS — para o hook funcionar corretamente.

### 6.2 — Testar o sync manualmente

Antes de configurar o hook, teste o script:

```bash
cmd /c "C:\kiro-sync\sync.bat"
```

A saida esperada e algo como:
- `nothing to commit` (se nao houver mudancas), ou
- `[master xxxxxxx] sync: atualizacao automatica de configs` seguido do push

### 6.3 — Criar o hook de sync automatico

No Kiro, abra uma nova sessao e execute o seguinte prompt:

```
Crie um hook com trigger Stop, comando: cmd /c "C:\kiro-sync\sync.bat", timeout 30, nome "Sync Kiro Config"
```

O Kiro vai criar o arquivo `.kiro/hooks/sync-kiro-config.json` automaticamente no workspace ativo.

---

## PASSO 7 — Apontar para seu proprio repositorio (opcional)

Se quiser usar seu proprio repo ao inves do original:

```bash
cd "C:\Users\<seu-usuario>\.kiro"
git remote set-url origin https://github.com/<seu-usuario>/kiro-config.git
git push -u origin master
```

---

## PASSO 8 — Reiniciar o Kiro

Feche e abra o Kiro para que:
- As steering files sejam carregadas
- Os MCPs conectem automaticamente
- O hook de sync seja registrado

---

## O que as steering files fazem

| Arquivo | Efeito |
|---------|--------|
| `steering/language.md` | Kiro sempre responde em portugues brasileiro |
| `steering/aws-calculator.md` | Antes de criar uma calculadora AWS, Kiro pergunta: regiao, cliente e modelo de precificacao. Titulo segue o padrao `Calculadora - <cliente> - <regiao> - <modelo>` |
| `steering/aws-diagrams.md` | Diagramas AWS salvos em `Desktop\Diagramas AWS Kiro\`, icones com cores corretas, layout horizontal, hierarquia AWS Cloud > Region > VPC > AZ > Subnets |

---

## Resolucao de problemas

**MCPs nao aparecem no Kiro / erro ao iniciar**
- Confirme que Node.js esta instalado em `C:\Program Files\nodejs\`: `dir "C:\Program Files\nodejs\node.exe"`
- Confirme que uvx esta instalado: `dir "C:\Users\<seu-usuario>\.local\bin\uvx.exe"`
- O mcp.json usa caminhos completos — confirme que os caminhos batem com sua instalacao
- Reconecte os MCPs pelo painel do Kiro (View > MCP Servers)

**Hook de sync nao funciona**
- Confirme que o arquivo `C:\kiro-sync\sync.bat` existe
- Teste manualmente: `cmd /c "C:\kiro-sync\sync.bat"`
- Confirme que o `.kiro` e um repositorio git: `cd "C:\Users\<seu-usuario>\.kiro" && git status`

**Sync commita arquivos indevidos (logs, sessoes)**
- Confirme que o `.gitignore` existe em `C:\Users\<seu-usuario>\.kiro\.gitignore`
- Remova do tracking: `git rm -r --cached logs/ sessions/` e faca um novo commit

**Erro de autenticacao no git push**
- Use um Personal Access Token como senha (nao a senha da conta)
- Crie em: https://github.com/settings/tokens/new (escopo: repo)

**git nao reconhecido no sync.bat**
- Use o caminho completo: `"C:\Program Files\Git\bin\git.exe"` dentro do bat
