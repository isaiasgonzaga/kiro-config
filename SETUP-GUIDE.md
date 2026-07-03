# Guia de Setup do Kiro — Configuração Completa (Admin)

Copie e cole este guia em qualquer sessão do Kiro para replicar toda a configuração.

---

## PRÉ-REQUISITOS — Antes de começar

Garanta que os itens abaixo estão instalados e funcionando antes de executar qualquer passo.

### 1. Kiro IDE
Baixe e instale o Kiro em: https://kiro.dev

### 2. Git
Necessário para clonar o repositório de configuração e para o sync automático.

- Download: https://git-scm.com/download/win
- Após instalar, verifique: `git --version`
- Configure sua identidade (obrigatório para commits):
  ```bash
  git config --global user.email "seu-email@exemplo.com"
  git config --global user.name "Seu Nome"
  ```
- Configure o armazenamento de credenciais para não precisar digitar senha toda vez:
  ```bash
  git config --global credential.helper manager
  ```

> Se `git` não for reconhecido no terminal após a instalação, adicione `C:\Program Files\Git\bin` ao PATH do sistema e reinicie o terminal.

### 3. Node.js
Necessário para os MCPs que usam `npx` (drawio-aws, drawio-official, aws-pricing-calculator).

- Download (versão LTS): https://nodejs.org
- Após instalar, verifique:
  ```bash
  node -v
  npm -v
  ```

### 4. uv (para MCPs com uvx)
Necessário para os MCPs que usam `uvx` (filesystem, git, fetch, brave-search, aws-docs, etc.).

Instale via PowerShell (não precisa de Python):
```powershell
powershell -ExecutionPolicy Bypass -Command "irm https://astral.sh/uv/install.ps1 | iex"
```

O instalador coloca o `uvx.exe` em `C:\Users\<seu-usuario>\.local\bin\`.

- Verifique (em um terminal novo):
  ```bash
  C:\Users\<seu-usuario>\.local\bin\uvx.exe --version
  ```

> Use sempre o **caminho completo** do uvx no mcp.json — o Kiro pode não enxergar o PATH do usuário.

### 5. Conta GitHub com Personal Access Token
Necessário para clonar o repositório (privado) e para o sync automático via push.

- Crie um token em: https://github.com/settings/tokens/new
- Escopos necessários: `repo` (acesso completo a repositórios)
- Guarde o token — ele será usado como senha ao clonar e no push automático

### Checklist rápido

| Item | Comando de verificação | Status esperado |
|------|------------------------|-----------------|
| Git | `git --version` | `git version 2.x.x` |
| Node.js | `node -v` | `v20.x.x` ou superior |
| npm | `npm -v` | `10.x.x` ou superior |
| uv/uvx | `C:\Users\<seu-usuario>\.local\bin\uvx.exe --version` | `uv x.x.x` |

> Todos os comandos acima devem funcionar em um terminal novo antes de prosseguir.

---

## PASSO 1 — Clonar o repositório de configuração

O repositório deve ser clonado em uma pasta temporária — **não diretamente no `.kiro`**, pois o Kiro já cria essa pasta com arquivos próprios ao ser instalado.

```bash
git clone https://github.com/isaiasgonzaga/kiro-config.git "C:\kiro-config-clone"
```

---

## PASSO 2 — Copiar as configurações para o Kiro

Copie os arquivos do clone para o diretório do Kiro:

```bash
:: Criar pasta settings se não existir
mkdir "C:\Users\<seu-usuario>\.kiro\settings"

:: mcp.json (template base — você vai preencher as keys no próximo passo)
copy "C:\kiro-config-clone\settings\mcp.template.json" "C:\Users\<seu-usuario>\.kiro\settings\mcp.json"

:: Steering files (regras e comportamentos do agente)
copy "C:\kiro-config-clone\steering\language.md" "C:\Users\<seu-usuario>\.kiro\steering\language.md"
copy "C:\kiro-config-clone\steering\aws-calculator.md" "C:\Users\<seu-usuario>\.kiro\steering\aws-calculator.md"
copy "C:\kiro-config-clone\steering\aws-diagrams.md" "C:\Users\<seu-usuario>\.kiro\steering\aws-diagrams.md"

:: Extensions e Powers
copy "C:\kiro-config-clone\extensions\extensions.json" "C:\Users\<seu-usuario>\.kiro\extensions\extensions.json"
copy "C:\kiro-config-clone\powers\installed.json" "C:\Users\<seu-usuario>\.kiro\powers\installed.json"
```

O que cada arquivo contém:

| Arquivo | Conteúdo |
|---------|----------|
| `steering/language.md` | Kiro responde em português brasileiro |
| `steering/aws-calculator.md` | Fluxo guiado para estimativas AWS |
| `steering/aws-diagrams.md` | Padrão de diagramas AWS |
| `extensions/extensions.json` | Extensões recomendadas |
| `powers/installed.json` | Powers configurados |
| `settings/mcp.json` | Configuração dos MCPs (não vai para o git) |

---

## PASSO 3 — Configurar o mcp.json com suas API keys

Abra o arquivo `C:\Users\<seu-usuario>\.kiro\settings\mcp.json` e substitua os placeholders:

- `<seu-usuario>` em todos os caminhos de `uvx.exe` → seu nome de usuário do Windows (ex: `joao.silva`)
- `GITHUB_TOKEN` → seu Personal Access Token do GitHub
- `BRAVE_API_KEY` → sua API key do Brave Search
- `DATABASE_URL` → sua string de conexão do banco
- `SLACK_BOT_TOKEN` / `SLACK_TEAM_ID` → credenciais do Slack

Para habilitar um servidor, mude `"disabled": true` para `"disabled": false`.

> O mcp.json já usa caminhos completos para `npx.cmd` e `uvx.exe` para garantir que os MCPs funcionem mesmo quando o PATH do sistema não inclui nodejs ou uv.

---

## PASSO 4 — MCPs já configurados e ativos

Os seguintes MCPs já estão ativos (`"disabled": false`) no template:

| MCP | Comando | O que faz |
|-----|---------|-----------|
| `drawio-aws` | `npx -y https://github.com/aws-samples/sample-drawio-mcp/...` | Diagramas AWS via Draw.io |
| `drawio-official` | `npx -y @drawio/mcp` | MCP oficial do Draw.io (XML, CSV, Mermaid) |
| `aws-pricing-calculator` | `npx -y sample-aws-pricing-calculator-mcp@latest` | Calculadora AWS via linguagem natural |

Os seguintes MCPs estão disponíveis mas **desativados** (precisam de API key):

| MCP | Ativar quando |
|-----|---------------|
| `filesystem` | Precisar dar acesso a arquivos locais |
| `git` | Quiser operações Git via agente |
| `fetch` | Quiser buscar conteúdo web |
| `brave-search` | Tiver uma Brave API key |
| `aws-docs` | Quiser documentação AWS inline |
| `postgres` | Tiver banco PostgreSQL local |
| `github` | Quiser operações no GitHub via agente |
| `slack` | Tiver um workspace Slack |

---

## PASSO 5 — Inicializar o Git no diretório do Kiro

O sync automático requer que o diretório `~\.kiro` seja um repositório Git conectado ao remote.

```bash
cd "C:\Users\<seu-usuario>\.kiro"

:: Inicializar o repositório
git init

:: Conectar ao remote
git remote add origin https://github.com/<seu-usuario>/kiro-config.git

:: Baixar o histórico e configurar o tracking
git fetch origin master
git update-ref refs/heads/master origin/master
git symbolic-ref HEAD refs/heads/master
git branch --set-upstream-to=origin/master master
git reset HEAD
```

> Este processo conecta o `.kiro` ao repositório remoto sem sobrescrever os arquivos existentes.

### Criar o .gitignore

Crie o arquivo `C:\Users\<seu-usuario>\.kiro\.gitignore` com o seguinte conteúdo:

```
# Secrets e tokens - NÃO versionar
settings/mcp.json

# Pasta interna de hooks do Kiro (local apenas)
.kiro/

# Logs e sessões (locais, não versionar)
logs/
sessions/
skills/
powers/registries/

# Arquivos de estado interno
.trust-migration.json
argv.json
```

> Este `.gitignore` garante que apenas `steering/`, `extensions/`, `powers/installed.json` e `settings/mcp.template.json` sejam versionados. Logs, sessões e o `mcp.json` com suas keys ficam apenas na sua máquina.

---

## PASSO 6 — Configurar o sync automático

O sync commita e faz push automaticamente das suas steering files e configurações após cada sessão do Kiro.

### 6.1 — Criar o script de sync

```bash
mkdir C:\kiro-sync
```

Crie o arquivo `C:\kiro-sync\sync.bat` com o seguinte conteúdo:

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

> Use o caminho completo do git (`C:\Program Files\Git\bin\git.exe`) para garantir que o script funcione mesmo quando o git não está no PATH do sistema.
> O script precisa estar em `C:\kiro-sync\` — caminho SEM ESPAÇOS — para o hook funcionar corretamente.

### 6.2 — Testar o sync manualmente

Antes de configurar o hook, teste o script:

```bash
cmd /c "C:\kiro-sync\sync.bat"
```

A saída esperada é algo como:
- `nothing to commit` (se não houver mudanças), ou
- `[master xxxxxxx] sync: atualizacao automatica de configs` seguido do push

### 6.3 — Criar o hook de sync automático

No Kiro, abra uma nova sessão e execute o seguinte prompt:

```
Crie um hook com trigger Stop, comando: cmd /c "C:\kiro-sync\sync.bat", timeout 30, nome "Sync Kiro Config"
```

O Kiro vai criar o arquivo `.kiro/hooks/sync-kiro-config.json` automaticamente no workspace ativo.

---

## PASSO 7 — Apontar para seu próprio repositório (opcional)

Se quiser usar seu próprio repo ao invés do original:

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
| `steering/language.md` | Kiro sempre responde em português brasileiro |
| `steering/aws-calculator.md` | Antes de criar uma calculadora AWS, Kiro pergunta: região, cliente e modelo de precificação. Título segue o padrão `Calculadora - <cliente> - <região> - <modelo>` |
| `steering/aws-diagrams.md` | Diagramas AWS salvos em `Desktop\Diagramas AWS Kiro\`, ícones com cores corretas, layout horizontal, hierarquia AWS Cloud > Region > VPC > AZ > Subnets |

---

## Resolução de problemas

**MCPs não aparecem no Kiro / erro ao iniciar**
- Confirme que Node.js está instalado em `C:\Program Files\nodejs\`: `dir "C:\Program Files\nodejs\node.exe"`
- Confirme que uvx está instalado: `dir "C:\Users\<seu-usuario>\.local\bin\uvx.exe"`
- O mcp.json usa caminhos completos — confirme que os caminhos batem com sua instalação
- Reconecte os MCPs pelo painel do Kiro (View > MCP Servers)

**Hook de sync não funciona**
- Confirme que o arquivo `C:\kiro-sync\sync.bat` existe
- Teste manualmente: `cmd /c "C:\kiro-sync\sync.bat"`
- Confirme que o `.kiro` é um repositório git: `cd "C:\Users\<seu-usuario>\.kiro" && git status`

**Sync commita arquivos indevidos (logs, sessões)**
- Confirme que o `.gitignore` existe em `C:\Users\<seu-usuario>\.kiro\.gitignore`
- Remova do tracking: `git rm -r --cached logs/ sessions/` e faça um novo commit

**Erro de autenticação no git push**
- Use um Personal Access Token como senha (não a senha da conta)
- Crie em: https://github.com/settings/tokens/new (escopo: repo)

**git não reconhecido no sync.bat**
- Use o caminho completo: `"C:\Program Files\Git\bin\git.exe"` dentro do bat
