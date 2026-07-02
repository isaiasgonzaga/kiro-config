@echo off
# kiro-config

Repositorio de configuracoes globais do Kiro para versionamento e portabilidade entre maquinas.

## Estrutura

`
.kiro/
├── .gitignore               # Ignora mcp.json (tem secrets)
├── sync.bat                 # Script de sync manual
├── sync.ps1                 # Script de sync via PowerShell
├── settings/
│   └── mcp.template.json    # Template dos MCPs (sem secrets)
└── steering/
    ├── language.md          # Regras globais de idioma e preferencias
    └── aws-calculator.md    # Regras para criacao de calculadoras AWS
`

## Como usar em uma nova maquina

1. Clone o repositorio na pasta correta:
   `ash
   git clone https://github.com/isaiasgonzaga/kiro-config.git "C:\Users\<seu-usuario>\.kiro"
   `

2. Copie o template e preencha suas API keys:
   `ash
   copy settings\mcp.template.json settings\mcp.json
   # edite mcp.json e substitua os placeholders pelas suas chaves reais
   `

3. Copie o script de sync para o caminho sem espacos:
   `ash
   mkdir C:\kiro-sync
   copy sync.bat C:\kiro-sync\sync.bat
   `

4. Reinicie o Kiro.

## Sync automatico (Hook)

O hook gentStop dispara automaticamente apos cada execucao do agente.

### Solucao encontrada

O Kiro executa hooks via CMD interno. Caminhos com espacos (como C:\Users\Isaias Santos\) causam falha mesmo entre aspas.

**Solucao que funcionou:** Colocar o .bat em um caminho sem espacos (C:\kiro-sync\sync.bat) e chamar via:

`
cmd /c "C:\kiro-sync\sync.bat"
`

**Abordagens que falharam:**
- && no comando do hook — Kiro escapa para &amp;&amp; automaticamente
- Chamar o .bat direto com caminho com espacos — CMD quebra no espaco mesmo com aspas
- .bat salvo com BOM (UTF-8 with BOM) — CMD nao reconhece o primeiro comando

### Hook configurado em:
`
C:\Users\Isaias Santos\.kiro\.kiro\hooks\sync-kiro-config.kiro.hook
`

Conteudo:
`json
{
  "enabled": true,
  "name": "Sync Kiro Config",
  "when": { "type": "agentStop" },
  "then": {
    "type": "runCommand",
    "command": "cmd /c \"C:\\kiro-sync\\sync.bat\"",
    "timeout": 30
  }
}
`

## Sync manual

`ash
cd "C:\Users\Isaias Santos\.kiro"
.\sync.bat
# ou
cmd /c "C:\kiro-sync\sync.bat"
`

## Observacoes

- settings/mcp.json esta no .gitignore pois contem API keys e tokens
- settings/mcp.template.json e a versao segura para versionar
- Os arquivos de steering sao carregados automaticamente pelo Kiro em todas as sessoes
