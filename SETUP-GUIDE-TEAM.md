# Guia de Setup do Kiro — Membros do Time

Este guia configura o Kiro na sua maquina com as configurações padrão do time.
Voce nao precisa (e nao deve) alterar o repositório — apenas recebe as atualizações do admin.

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

> Se `git` não for reconhecido no terminal após a instalação, reinicie o terminal ou o Windows.

### 3. Node.js
Necessário para os MCPs que usam `npx` (drawio-aws, drawio-official, aws-pricing-calculator).

- Download (versão LTS): https://nodejs.org
- Após instalar, verifique:
  ```bash
  node -v
  npm -v
  ```

### 4. Python + uv (para MCPs com uvx)
Necessário se quiser ativar MCPs como filesystem, git, fetch, brave-search, aws-docs, etc.

- Download Python: https://www.python.org/downloads/
- Após instalar Python, instale o uv:
  ```bash
  pip install uv
  ```
- Verifique:
  ```bash
  uvx --version
  ```

### Checklist rápido

| Item | Comando de verificação | Status esperado |
|------|------------------------|-----------------|
| Git | `git --version` | `git version 2.x.x` |
| Node.js | `node -v` | `v20.x.x` ou superior |
| npm | `npm -v` | `10.x.x` ou superior |
| Python | `python --version` | `3.10` ou superior |
| uv/uvx | `uvx --version` | `uv x.x.x` |

> Todos os comandos acima devem funcionar em um terminal novo antes de prosseguir.

---

## PASSO 1 — Clonar as configurações do time

Abra o terminal e execute:

```bash
git clone https://github.com/isaiasgonzaga/kiro-config.git "C:\Users\<seu-usuário>\.kiro"
```

> Substitua `<seu-usuário>` pelo seu nome de usuário do Windows.
> Exemplo: `C:\Users\joao.silva\.kiro`

---

## PASSO 2 — Verificar os arquivos recebidos do repositório

Após clonar, confirme que os seguintes arquivos e pastas estão presentes no seu `.kiro`:

```bash
dir "C:\Users\<seu-usuário>\.kiro\steering"
dir "C:\Users\<seu-usuário>\.kiro\extensions"
dir "C:\Users\<seu-usuário>\.kiro\powers"
dir "C:\Users\<seu-usuário>\.kiro\settings"
```

O que você deve encontrar:

| Pasta / Arquivo | O que faz |
|-----------------|-----------|
| `steering/language.md` | Kiro responde em português brasileiro |
| `steering/aws-calculator.md` | Fluxo guiado para estimativas AWS |
| `steering/aws-diagrams.md` | Padrão de diagramas AWS do time |
| `extensions/extensions.json` | Extensões recomendadas do time |
| `powers/installed.json` | Powers configurados |
| `settings/mcp.template.json` | Base para o seu `mcp.json` |

Se alguma pasta estiver vazia ou ausente, rode manualmente:

```bash
cd "C:\Users\<seu-usuário>\.kiro"
git pull origin master
```

---

## PASSO 3 — Configurar o mcp.json

```bash
copy "C:\Users\<seu-usuário>\.kiro\settings\mcp.template.json" "C:\Users\<seu-usuário>\.kiro\settings\mcp.json"
```

O arquivo `mcp.json` esta no `.gitignore` — suas credenciais ficam **apenas na sua maquina**, nao vao para o repositório.

Abra o `mcp.json` e preencha suas chaves nos campos necessários (os MCPs de Draw.io e AWS Calculator nao precisam de chave — ja funcionam direto).

---

## PASSO 4 — Bloquear push acidental

Para garantir que voce nao faca push por engano, execute:

```bash
cd "C:\Users\<seu-usuário>\.kiro"
git remote set-url --push origin no-push
```

> Isso faz com que qualquer tentativa de `git push` falhe com "no-push", protegendo o repositório do time.

---

## PASSO 5 — Criar o script de sync (apenas pull)

Crie a pasta e o script:

```bash
mkdir C:\kiro-sync
```

Crie o arquivo `C:\kiro-sync\sync.bat` com o seguinte conteúdo:

```bat
@echo off
cd /d "C:\Users\<seu-usuário>\.kiro"
git pull --rebase origin master
```

> Este script apenas **recebe** atualizações do admin. Nao faz commit nem push.

---

## PASSO 6 — Criar o hook de atualização automática

Crie a pasta se nao existir:
```bash
mkdir "C:\Users\<seu-usuário>\.kiro\.kiro\hooks"
```

Crie o arquivo `sync-kiro-config.kiro.hook` dentro dessa pasta:

```json
{
  "enabled": true,
  "name": "Sync Kiro Config",
  "description": "Recebe atualizações de configuração do time automaticamente",
  "version": "1",
  "when": {
    "type": "agentStop"
  },
  "then": {
    "type": "runCommand",
    "command": "cmd /c \"C:\\kiro-sync\\sync.bat\"",
    "timeout": 30
  }
}
```

---

## PASSO 7 — Reiniciar o Kiro

Feche e abra o Kiro. As configurações do time serão carregadas automaticamente.

---

## Como receber atualizações do admin

Sempre que o admin atualizar as configurações, seu Kiro vai sincronizar automaticamente ao final de cada execução do agente.

Para atualizar manualmente a qualquer momento:

```bash
cmd /c "C:\kiro-sync\sync.bat"
```

---

## MCPs disponíveis apos o setup

| MCP | Status | O que faz |
|-----|--------|-----------|
| `drawio-aws` | Ativo | Diagramas AWS via Draw.io |
| `drawio-official` | Ativo | MCP oficial Draw.io |
| `aws-pricing-calculator` | Ativo | Calculadora AWS |
| `github`, `slack`, etc. | Desativado | Ative preenchendo sua API key no mcp.json |

---

## Resolução de problemas

**Erro ao fazer pull: "divergent branches"**
```bash
cd "C:\Users\<seu-usuário>\.kiro"
git fetch origin
git reset --hard origin/master
```

**MCPs nao aparecem**
- Verifique se Node.js esta instalado: `node -v`
- Reconecte pelo painel do Kiro (View > MCP Servers)

**Quero sugerir uma mudança nas configurações**
- Fale com o admin (Isaias Santos) — ele faz a alteração e voce recebe automaticamente no proximo sync.
