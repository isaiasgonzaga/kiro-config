# Guia de Setup do Kiro — Membros do Time

Este guia configura o Kiro na sua maquina com as configuracoes padrao do time.
Voce nao precisa (e nao deve) alterar o repositorio — apenas recebe as atualizacoes do admin.

---

## Pre-requisitos

- [ ] Kiro instalado
- [ ] Git instalado: https://git-scm.com/download/win
- [ ] Node.js instalado: https://nodejs.org

---

## PASSO 1 — Clonar as configuracoes do time

Abra o terminal e execute:

```bash
git clone https://github.com/isaiasgonzaga/kiro-config.git "C:\Users\<seu-usuario>\.kiro"
```

> Substitua `<seu-usuario>` pelo seu nome de usuario do Windows.
> Exemplo: `C:\Users\joao.silva\.kiro`

---

## PASSO 2 — Configurar o mcp.json

```bash
copy "C:\Users\<seu-usuario>\.kiro\settings\mcp.template.json" "C:\Users\<seu-usuario>\.kiro\settings\mcp.json"
```

O arquivo `mcp.json` esta no `.gitignore` — suas credenciais ficam **apenas na sua maquina**, nao vao para o repositorio.

Abra o `mcp.json` e preencha suas chaves nos campos necessarios (os MCPs de Draw.io e AWS Calculator nao precisam de chave — ja funcionam direto).

---

## PASSO 3 — Configurar identidade Git (somente leitura)

```bash
git config --global user.email "seu-email@empresa.com"
git config --global user.name "Seu Nome"
```

---

## PASSO 4 — Bloquear push acidental

Para garantir que voce nao faca push por engano, execute:

```bash
cd "C:\Users\<seu-usuario>\.kiro"
git remote set-url --push origin no-push
```

> Isso faz com que qualquer tentativa de `git push` falhe com "no-push", protegendo o repositorio do time.

---

## PASSO 5 — Criar o script de sync (apenas pull)

Crie a pasta e o script:

```bash
mkdir C:\kiro-sync
```

Crie o arquivo `C:\kiro-sync\sync.bat` com o seguinte conteudo:

```bat
@echo off
cd /d "C:\Users\<seu-usuario>\.kiro"
git pull --rebase origin master
```

> Este script apenas **recebe** atualizacoes do admin. Nao faz commit nem push.

---

## PASSO 6 — Criar o hook de atualizacao automatica

Crie a pasta se nao existir:
```bash
mkdir "C:\Users\<seu-usuario>\.kiro\.kiro\hooks"
```

Crie o arquivo `sync-kiro-config.kiro.hook` dentro dessa pasta:

```json
{
  "enabled": true,
  "name": "Sync Kiro Config",
  "description": "Recebe atualizacoes de configuracao do time automaticamente",
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

**Erro ao fazer pull: "divergent branches"**
```bash
cd "C:\Users\<seu-usuario>\.kiro"
git fetch origin
git reset --hard origin/master
```

**MCPs nao aparecem**
- Verifique se Node.js esta instalado: `node -v`
- Reconecte pelo painel do Kiro (View > MCP Servers)

**Quero sugerir uma mudanca nas configuracoes**
- Fale com o admin (Isaias Santos) — ele faz a alteracao e voce recebe automaticamente no proximo sync.