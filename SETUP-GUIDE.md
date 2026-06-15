# Guia de Setup do Kiro — Configuracao Completa

Copie e cole este guia em qualquer sessao do Kiro para replicar toda a configuracao.

---

## PASSO 1 — Clonar as configuracoes globais

```bash
git clone https://github.com/isaiasgonzaga/kiro-config.git "C:\Users\<seu-usuario>\.kiro"
```

> Substitua `<seu-usuario>` pelo seu nome de usuario do Windows.

---

## PASSO 2 — Configurar o mcp.json com suas API keys

```bash
copy "C:\Users\<seu-usuario>\.kiro\settings\mcp.template.json" "C:\Users\<seu-usuario>\.kiro\settings\mcp.json"
```

Abra o `mcp.json` e substitua os placeholders pelas suas chaves reais:
- `GITHUB_TOKEN` -> seu Personal Access Token do GitHub
- `BRAVE_API_KEY` -> sua API key do Brave Search
- `DATABASE_URL` -> sua string de conexao do banco
- `SLACK_BOT_TOKEN` / `SLACK_TEAM_ID` -> credenciais do Slack

Para habilitar um servidor, mude `"disabled": true` para `"disabled": false`.

---

## PASSO 3 — MCPs ja configurados e ativos

Os seguintes MCPs ja estao ativos (`"disabled": false`) no template:

| MCP | Comando | O que faz |
|-----|---------|-----------|
| `drawio-aws` | `npx -y https://github.com/aws-samples/sample-drawio-mcp/...` | Diagramas AWS via Draw.io |
| `drawio-official` | `npx -y @drawio/mcp` | MCP oficial do Draw.io (XML, CSV, Mermaid) |
| `aws-pricing-calculator` | `npx -y sample-aws-pricing-calculator-mcp@latest` | Calculadora AWS via linguagem natural |

> Requer Node.js instalado: https://nodejs.org

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

## PASSO 4 — Configurar sync automatico com Git

### 4.1 — Instalar Git
https://git-scm.com/download/win

### 4.2 — Configurar identidade
```bash
git config --global user.email "seu-email@exemplo.com"
git config --global user.name "Seu Nome"
```

### 4.3 — Criar o script de sync sem espacos no caminho
```bash
mkdir C:\kiro-sync
copy "C:\Users\<seu-usuario>\.kiro\sync.bat" C:\kiro-sync\sync.bat
```

### 4.4 — Criar o hook de sync automatico

Crie o arquivo:
```
C:\Users\<seu-usuario>\.kiro\.kiro\hooks\sync-kiro-config.kiro.hook
```

Com o conteudo:
```json
{
  "enabled": true,
  "name": "Sync Kiro Config",
  "description": "Faz commit e push automatico apos cada execucao do agente",
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

> IMPORTANTE: O hook usa `cmd /c "C:\kiro-sync\sync.bat"` porque o Kiro escapa `&&` automaticamente.
> O bat precisa estar em caminho SEM ESPACOS para funcionar corretamente.

---

## PASSO 5 — Apontar para seu proprio repositorio (opcional)

Se quiser usar seu proprio repo ao inves do original:

```bash
cd "C:\Users\<seu-usuario>\.kiro"
git remote set-url origin https://github.com/<seu-usuario>/kiro-config.git
git push -u origin master
```

---

## PASSO 6 — Reiniciar o Kiro

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
| `steering/aws-diagrams.md` | Diagramas AWS salvos em `Desktop\Diagramas AWS Kiro\`, icones com cores corretas, layout horizontal, hierarquia AWS Cloud > Region > VPC > AZ > Subnets, usando apenas os MCPs `mcp_drawio_official_open_drawio_xml` e `mcp_drawio_aws_save_diagram` |

---

## Resolucao de problemas

**MCPs nao aparecem no Kiro**
- Verifique se Node.js esta instalado: `node -v`
- Verifique se uvx esta instalado: `uvx --version` (se nao, instale: `pip install uv`)
- Reconecte os MCPs pelo painel do Kiro (View > MCP Servers)

**Hook de sync nao funciona**
- Confirme que o arquivo `C:\kiro-sync\sync.bat` existe
- Confirme que o Git esta no PATH: `git --version`
- Rode manualmente para testar: `cmd /c "C:\kiro-sync\sync.bat"`

**Erro de autenticacao no git push**
- Use um Personal Access Token como senha (nao a senha da conta)
- Crie em: https://github.com/settings/tokens/new (escopo: repo)