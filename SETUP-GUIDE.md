# Guia de Setup do Kiro — Configuracao Completa

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

> Se `git` nao for reconhecido no terminal apos a instalacao, reinicie o terminal ou o Windows.

### 3. Node.js
Necessario para os MCPs que usam `npx` (drawio-aws, drawio-official, aws-pricing-calculator).

- Download (versao LTS): https://nodejs.org
- Apos instalar, verifique:
  ```bash
  node -v
  npm -v
  ```

### 4. Python + uv (para MCPs com uvx)
Necessario para os MCPs que usam `uvx` (filesystem, git, fetch, brave-search, aws-docs, etc.).

- Download Python: https://www.python.org/downloads/
- Apos instalar Python, instale o uv:
  ```bash
  pip install uv
  ```
- Verifique:
  ```bash
  uvx --version
  ```

### 5. Conta GitHub com Personal Access Token
Necessario para clonar o repositorio (se privado) e para o sync automatico via push.

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
| uv/uvx | `uvx --version` | `uv x.x.x` |

> Todos os comandos acima devem funcionar em um terminal novo antes de prosseguir.

---

## PASSO 1 — Clonar as configuracoes globais

```bash
git clone https://github.com/isaiasgonzaga/kiro-config.git "C:\Users\<seu-usuario>\.kiro"
```

> Substitua `<seu-usuario>` pelo seu nome de usuario do Windows.

---

## PASSO 2 — Copiar configuracoes do repositorio para o Kiro

Apos clonar, copie todas as pastas e arquivos de configuracao do repositorio para o diretorio do Kiro:

```bash
:: Steering files (regras e comportamentos do agente)
xcopy /E /I /Y "C:\Users\<seu-usuario>\.kiro\steering" "C:\Users\<seu-usuario>\.kiro\steering"

:: Extensions (extensoes recomendadas)
copy "C:\Users\<seu-usuario>\.kiro\extensions\extensions.json" "C:\Users\<seu-usuario>\.kiro\extensions\extensions.json"

:: Powers (poderes instalados)
copy "C:\Users\<seu-usuario>\.kiro\powers\installed.json" "C:\Users\<seu-usuario>\.kiro\powers\installed.json"

:: argv.json (configuracoes de inicializacao)
copy "C:\Users\<seu-usuario>\.kiro\argv.json" "C:\Users\<seu-usuario>\.kiro\argv.json"
```

> Como o clone ja vai direto para `C:\Users\<seu-usuario>\.kiro`, esses arquivos ja estarao no lugar certo automaticamente. Este passo so e necessario se voce clonou em outro diretorio.

O que cada pasta contem:

| Pasta / Arquivo | Conteudo |
|-----------------|----------|
| `steering/` | Regras de comportamento do agente (idioma, diagramas AWS, calculadora) |
| `extensions/extensions.json` | Lista de extensoes recomendadas do time |
| `powers/installed.json` | Powers instalados e configurados |
| `settings/mcp.template.json` | Template dos MCPs — base para o seu `mcp.json` |
| `argv.json` | Argumentos de inicializacao do Kiro |

---

## PASSO 3 — Configurar o mcp.json com suas API keys

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

## PASSO 4 — MCPs ja configurados e ativos

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

## PASSO 5 — Configurar sync automatico com Git

### 5.1 — Criar o script de sync sem espacos no caminho
```bash
mkdir C:\kiro-sync
copy "C:\Users\<seu-usuario>\.kiro\sync.bat" C:\kiro-sync\sync.bat
```

### 5.2 — Criar o hook de sync automatico

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

## PASSO 6 — Apontar para seu proprio repositorio (opcional)

Se quiser usar seu proprio repo ao inves do original:

```bash
cd "C:\Users\<seu-usuario>\.kiro"
git remote set-url origin https://github.com/<seu-usuario>/kiro-config.git
git push -u origin master
```

---

## PASSO 7 — Reiniciar o Kiro

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