# Guia de Setup do Kiro — Membros do Time

Este guia configura o Kiro na sua maquina com as configuracoes padrao do time.
Voce nao precisa (e nao deve) alterar o repositorio — apenas recebe as atualizacoes do admin.

---

## Pre-requisitos — Antes de comecar

Garanta que os itens abaixo estao instalados e funcionando antes de executar qualquer passo.

### 1. Kiro IDE
Baixe e instale o Kiro em: https://kiro.dev

### 2. Git
Necessario para clonar o repositorio do time e receber atualizacoes automaticas.

- Download: https://git-scm.com/download/win
- Apos instalar, verifique: `git --version`
- Configure sua identidade (obrigatorio para o git funcionar):
  ```bash
  git config --global user.email "seu-email@empresa.com"
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
Necessario se quiser ativar MCPs como filesystem, git, fetch, brave-search, aws-docs, etc.

Instale via PowerShell (nao precisa de Python):
```powershell
powershell -ExecutionPolicy Bypass -Command "irm https://astral.sh/uv/install.ps1 | iex"
```

O instalador coloca o `uvx.exe` em `C:\Users\<seu-usuario>\.local\bin\`.

- Verifique (em um terminal novo):
  ```bash
  C:\Users\<seu-usuario>\.local\bin\uvx.exe --version
  ```

> Use sempre o **caminho completo** do uvx no mcp.json.

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

## PASSO 1 — Clonar as configuracoes do time

O repositorio deve ser clonado em uma pasta temporaria — **nao diretamente no `.kiro`**, pois o Kiro ja cria essa pasta com arquivos proprios ao ser instalado.

```bash
git clone https://github.com/isaiasgonzaga/kiro-config.git "C:\kiro-config-clone"
```

---

## PASSO 2 — Copiar as configuracoes para o Kiro

Copie os arquivos relevantes do clone para o diretorio do Kiro:

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

Confirme que os arquivos estao no lugar:

```bash
dir "C:\Users\<seu-usuario>\.kiro\steering"
dir "C:\Users\<seu-usuario>\.kiro\settings"
```

O que voce deve encontrar:

| Arquivo | O que faz |
|---------|-----------|
| `steering/language.md` | Kiro responde em portugues brasileiro |
| `steering/aws-calculator.md` | Fluxo guiado para estimativas AWS |
| `steering/aws-diagrams.md` | Padrao de diagramas AWS do time |
| `extensions/extensions.json` | Extensoes recomendadas do time |
| `powers/installed.json` | Powers configurados |
| `settings/mcp.json` | Configuracao dos MCPs (nao vai para o git) |

---

## PASSO 3 — Configurar o mcp.json

Abra o arquivo `C:\Users\<seu-usuario>\.kiro\settings\mcp.json` e substitua os placeholders:

- `<seu-usuario>` em todos os caminhos de `uvx.exe` -> seu nome de usuario do Windows (ex: `joao.silva`)
- Preencha as API keys dos MCPs que quiser ativar

Os MCPs de Draw.io e AWS Calculator **nao precisam de chave** — ja funcionam direto apos o setup.

O arquivo `mcp.json` esta no `.gitignore` — suas credenciais ficam **apenas na sua maquina**, nao vao para o repositorio.

> O mcp.json ja usa caminhos completos para `npx.cmd` e `uvx.exe`. Isso e necessario porque o Kiro pode nao enxergar o PATH do sistema corretamente no Windows.

---

## PASSO 4 — Bloquear alteracoes acidentais no repositorio

Como membro do time, voce nao deve modificar o repositorio de configuracoes. Execute os comandos abaixo para proteger contra alteracoes acidentais:

```bash
cd "C:\kiro-config-clone"

:: Bloquear push
git remote set-url --push origin no-push
```

> Qualquer tentativa de `git push` vai falhar com "no-push", protegendo o repositorio do time.
> Apenas o admin (Isaias Santos) tem permissao de alterar as configuracoes.

---

## PASSO 5 — Configurar o sync automatico (apenas pull)

O sync baixa atualizacoes do admin automaticamente ao final de cada sessao do Kiro. Voce **nao faz commit nem push** — apenas recebe.

### 5.1 — Criar o script de sync

```bash
mkdir C:\kiro-sync
```

Crie o arquivo `C:\kiro-sync\sync.bat` com o seguinte conteudo:

```bat
@echo off
cd /d "C:\Users\<seu-usuario>\.kiro"
"C:\Program Files\Git\bin\git.exe" pull --rebase origin master
```

> Use o caminho completo do git (`C:\Program Files\Git\bin\git.exe`) para garantir que o script funcione mesmo quando o git nao esta no PATH do sistema.
> O script precisa estar em `C:\kiro-sync\` — caminho SEM ESPACOS — para o hook funcionar corretamente.

### 5.2 — Inicializar o Git no diretorio do Kiro

Para que o sync funcione, o `.kiro` precisa estar conectado ao repositorio remoto em modo somente leitura:

```bash
cd "C:\Users\<seu-usuario>\.kiro"

:: Inicializar o repositorio
git init

:: Conectar ao remote
git remote add origin https://github.com/isaiasgonzaga/kiro-config.git

:: Baixar o historico e configurar o tracking
git fetch origin master
git update-ref refs/heads/master origin/master
git symbolic-ref HEAD refs/heads/master
git branch --set-upstream-to=origin/master master
git reset HEAD

:: Bloquear push (protecao adicional)
git remote set-url --push origin no-push
```

### 5.3 — Testar o sync manualmente

```bash
cmd /c "C:\kiro-sync\sync.bat"
```

A saida esperada e algo como `Already up to date.` ou uma lista de arquivos atualizados.

### 5.4 — Criar o hook de atualizacao automatica

No Kiro, abra uma nova sessao e execute o seguinte prompt:

```
Crie um hook com trigger Stop, comando: cmd /c "C:\kiro-sync\sync.bat", timeout 30, nome "Sync Kiro Config"
```

O Kiro vai criar o arquivo `.kiro/hooks/sync-kiro-config.json` automaticamente no workspace ativo.

---

## PASSO 6 — Reiniciar o Kiro

Feche e abra o Kiro. As configuracoes do time serao carregadas automaticamente.

---

## Como receber atualizacoes do admin

Sempre que o admin atualizar as configuracoes, seu Kiro vai sincronizar automaticamente ao final de cada execucao do agente.

Para atualizar manualmente a qualquer momento:

```bash
cmd /c "C:\kiro-sync\sync.bat"
```

---

## MCPs disponiveis apos o setup

| MCP | Status | O que faz |
|-----|--------|-----------|
| `drawio-aws` | Ativo | Diagramas AWS via Draw.io |
| `drawio-official` | Ativo | MCP oficial Draw.io |
| `aws-pricing-calculator` | Ativo | Calculadora AWS |
| `github`, `slack`, etc. | Desativado | Ative preenchendo sua API key no mcp.json |

---

## Resolucao de problemas

**Sync nao baixa atualizacoes**
- Confirme que o `.kiro` esta conectado ao remote: `cd "C:\Users\<seu-usuario>\.kiro" && git remote -v`
- Teste manualmente: `cmd /c "C:\kiro-sync\sync.bat"`

**Erro "divergent branches" ao fazer pull**
```bash
cd "C:\Users\<seu-usuario>\.kiro"
"C:\Program Files\Git\bin\git.exe" fetch origin
"C:\Program Files\Git\bin\git.exe" reset --hard origin/master
```

**MCPs nao aparecem / erro ao iniciar**
- Confirme que Node.js esta em `C:\Program Files\nodejs\`: `dir "C:\Program Files\nodejs\node.exe"`
- Confirme que uvx esta instalado: `dir "C:\Users\<seu-usuario>\.local\bin\uvx.exe"`
- O mcp.json usa caminhos completos — confirme que os caminhos batem com sua instalacao
- Reconecte pelo painel do Kiro (View > MCP Servers)

**git nao reconhecido no sync.bat**
- Use o caminho completo: `"C:\Program Files\Git\bin\git.exe"` dentro do bat

**Quero sugerir uma mudanca nas configuracoes**
- Fale com o admin (Isaias Santos) — ele faz a alteracao e voce recebe automaticamente no proximo sync.
