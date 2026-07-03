# Guia de Setup do Kiro — Membros do Time

Este guia configura o Kiro na sua máquina com as configurações padrão do time.
Você não precisa (e não deve) alterar o repositório — apenas recebe as atualizações do admin.

---

## Pré-requisitos — Antes de começar

Garanta que os itens abaixo estão instalados e funcionando antes de executar qualquer passo.

### 1. Kiro IDE
Baixe e instale o Kiro em: https://kiro.dev

### 2. Git
Necessário para clonar o repositório do time e receber atualizações automáticas.

- Download: https://git-scm.com/download/win
- Após instalar, verifique: `git --version`
- Configure sua identidade (obrigatório para o git funcionar):
  ```bash
  git config --global user.email "seu-email@empresa.com"
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
Necessário se quiser ativar MCPs como filesystem, git, fetch, brave-search, aws-docs, etc.

Instale via PowerShell (não precisa de Python):
```powershell
powershell -ExecutionPolicy Bypass -Command "irm https://astral.sh/uv/install.ps1 | iex"
```

O instalador coloca o `uvx.exe` em `C:\Users\<seu-usuario>\.local\bin\`.

- Verifique (em um terminal novo):
  ```bash
  C:\Users\<seu-usuario>\.local\bin\uvx.exe --version
  ```

> Use sempre o **caminho completo** do uvx no mcp.json.

### Checklist rápido

| Item | Comando de verificação | Status esperado |
|------|------------------------|-----------------|
| Git | `git --version` | `git version 2.x.x` |
| Node.js | `node -v` | `v20.x.x` ou superior |
| npm | `npm -v` | `10.x.x` ou superior |
| uv/uvx | `C:\Users\<seu-usuario>\.local\bin\uvx.exe --version` | `uv x.x.x` |

> Todos os comandos acima devem funcionar em um terminal novo antes de prosseguir.

---

## PASSO 1 — Clonar as configurações do time

O repositório deve ser clonado em uma pasta temporária — **não diretamente no `.kiro`**, pois o Kiro já cria essa pasta com arquivos próprios ao ser instalado.

```bash
git clone https://github.com/isaiasgonzaga/kiro-config.git "C:\kiro-config-clone"
```

---

## PASSO 2 — Copiar as configurações para o Kiro

Copie os arquivos relevantes do clone para o diretório do Kiro:

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

Confirme que os arquivos estão no lugar:

```bash
dir "C:\Users\<seu-usuario>\.kiro\steering"
dir "C:\Users\<seu-usuario>\.kiro\settings"
```

O que você deve encontrar:

| Arquivo | O que faz |
|---------|-----------|
| `steering/language.md` | Kiro responde em português brasileiro |
| `steering/aws-calculator.md` | Fluxo guiado para estimativas AWS |
| `steering/aws-diagrams.md` | Padrão de diagramas AWS do time |
| `extensions/extensions.json` | Extensões recomendadas do time |
| `powers/installed.json` | Powers configurados |
| `settings/mcp.json` | Configuração dos MCPs (não vai para o git) |

---

## PASSO 3 — Configurar o mcp.json

Abra o arquivo `C:\Users\<seu-usuario>\.kiro\settings\mcp.json` e substitua os placeholders:

- `<seu-usuario>` em todos os caminhos de `uvx.exe` → seu nome de usuário do Windows (ex: `joao.silva`)
- Preencha as API keys dos MCPs que quiser ativar

Os MCPs de Draw.io e AWS Calculator **não precisam de chave** — já funcionam direto após o setup.

O arquivo `mcp.json` está no `.gitignore` — suas credenciais ficam **apenas na sua máquina**, não vão para o repositório.

> O mcp.json já usa caminhos completos para `npx.cmd` e `uvx.exe`. Isso é necessário porque o Kiro pode não enxergar o PATH do sistema corretamente no Windows.

---

## PASSO 4 — Bloquear alterações acidentais no repositório

Como membro do time, você não deve modificar o repositório de configurações. Execute os comandos abaixo para se proteger contra alterações acidentais:

```bash
cd "C:\kiro-config-clone"

:: Bloquear push
git remote set-url --push origin no-push
```

> Qualquer tentativa de `git push` vai falhar com "no-push", protegendo o repositório do time.
> Apenas o admin (Isaias Santos) tem permissão de alterar as configurações.

---

## PASSO 5 — Configurar o sync automático (apenas pull)

O sync baixa atualizações do admin automaticamente ao final de cada sessão do Kiro. Você **não faz commit nem push** — apenas recebe.

### 5.1 — Criar o script de sync

```bash
mkdir C:\kiro-sync
```

Crie o arquivo `C:\kiro-sync\sync.bat` com o seguinte conteúdo:

```bat
@echo off
cd /d "C:\Users\<seu-usuario>\.kiro"
"C:\Program Files\Git\bin\git.exe" pull --rebase origin master
```

> Use o caminho completo do git (`C:\Program Files\Git\bin\git.exe`) para garantir que o script funcione mesmo quando o git não está no PATH do sistema.
> O script precisa estar em `C:\kiro-sync\` — caminho SEM ESPAÇOS — para o hook funcionar corretamente.

### 5.2 — Inicializar o Git no diretório do Kiro

Para que o sync funcione, o `.kiro` precisa estar conectado ao repositório remoto em modo somente leitura:

```bash
cd "C:\Users\<seu-usuario>\.kiro"

:: Inicializar o repositório
git init

:: Conectar ao remote
git remote add origin https://github.com/isaiasgonzaga/kiro-config.git

:: Baixar o histórico e configurar o tracking
git fetch origin master
git update-ref refs/heads/master origin/master
git symbolic-ref HEAD refs/heads/master
git branch --set-upstream-to=origin/master master
git reset HEAD

:: Bloquear push (proteção adicional)
git remote set-url --push origin no-push
```

### 5.3 — Testar o sync manualmente

```bash
cmd /c "C:\kiro-sync\sync.bat"
```

A saída esperada é algo como `Already up to date.` ou uma lista de arquivos atualizados.

### 5.4 — Criar o hook de atualização automática

No Kiro, abra uma nova sessão e execute o seguinte prompt:

```
Crie um hook com trigger Stop, comando: cmd /c "C:\kiro-sync\sync.bat", timeout 30, nome "Sync Kiro Config"
```

O Kiro vai criar o arquivo `.kiro/hooks/sync-kiro-config.json` automaticamente no workspace ativo.

---

## PASSO 6 — Reiniciar o Kiro

Feche e abra o Kiro. As configurações do time serão carregadas automaticamente.

---

## Como receber atualizações do admin

Sempre que o admin atualizar as configurações, seu Kiro vai sincronizar automaticamente ao final de cada execução do agente.

Para atualizar manualmente a qualquer momento:

```bash
cmd /c "C:\kiro-sync\sync.bat"
```

---

## MCPs disponíveis após o setup

| MCP | Status | O que faz |
|-----|--------|-----------|
| `drawio-aws` | Ativo | Diagramas AWS via Draw.io |
| `drawio-official` | Ativo | MCP oficial Draw.io |
| `aws-pricing-calculator` | Ativo | Calculadora AWS |
| `github`, `slack`, etc. | Desativado | Ative preenchendo sua API key no mcp.json |

---

## Resolução de problemas

**Sync não baixa atualizações**
- Confirme que o `.kiro` está conectado ao remote: `cd "C:\Users\<seu-usuario>\.kiro" && git remote -v`
- Teste manualmente: `cmd /c "C:\kiro-sync\sync.bat"`

**Erro "divergent branches" ao fazer pull**
```bash
cd "C:\Users\<seu-usuario>\.kiro"
"C:\Program Files\Git\bin\git.exe" fetch origin
"C:\Program Files\Git\bin\git.exe" reset --hard origin/master
```

**MCPs não aparecem / erro ao iniciar**
- Confirme que Node.js está em `C:\Program Files\nodejs\`: `dir "C:\Program Files\nodejs\node.exe"`
- Confirme que uvx está instalado: `dir "C:\Users\<seu-usuario>\.local\bin\uvx.exe"`
- O mcp.json usa caminhos completos — confirme que os caminhos batem com sua instalação
- Reconecte pelo painel do Kiro (View > MCP Servers)

**git não reconhecido no sync.bat**
- Use o caminho completo: `"C:\Program Files\Git\bin\git.exe"` dentro do bat

**Quero sugerir uma mudança nas configurações**
- Fale com o admin (Isaias Santos) — ele faz a alteração e você recebe automaticamente no próximo sync.
