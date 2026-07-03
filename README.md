# kiro-config

Repositório de configurações globais do Kiro para versionamento e portabilidade entre máquinas.

## Estrutura

```
kiro-config/
├── .gitignore                  # Ignora mcp.json (contém secrets)
├── sync.bat                    # Script de sync manual
├── sync.ps1                    # Script de sync via PowerShell
├── SETUP-GUIDE.md              # Guia completo de setup (admin)
├── SETUP-GUIDE-TEAM.md         # Guia de setup para membros do time
├── settings/
│   └── mcp.template.json       # Template dos MCPs (sem secrets)
├── steering/
│   ├── language.md             # Regras globais de idioma e preferências
│   ├── aws-calculator.md       # Regras para criação de calculadoras AWS
│   └── aws-diagrams.md         # Regras para criação de diagramas AWS
├── extensions/
│   └── extensions.json         # Extensões recomendadas
└── powers/
    └── installed.json          # Powers instalados e configurados
```

## Como usar em uma nova máquina

Consulte o guia completo correspondente ao seu perfil:

- **Admin**: [SETUP-GUIDE.md](./SETUP-GUIDE.md)
- **Membro do time**: [SETUP-GUIDE-TEAM.md](./SETUP-GUIDE-TEAM.md)

Resumo rápido:

1. Clone o repositório em uma pasta temporária:
   ```bash
   git clone https://github.com/isaiasgonzaga/kiro-config.git "C:\kiro-config-clone"
   ```

2. Copie o template e preencha suas API keys:
   ```bash
   mkdir "C:\Users\<seu-usuario>\.kiro\settings"
   copy "C:\kiro-config-clone\settings\mcp.template.json" "C:\Users\<seu-usuario>\.kiro\settings\mcp.json"
   ```
   Substitua `<seu-usuario>` nos caminhos de `uvx.exe` pelo seu nome de usuário do Windows.

3. Copie as steering files:
   ```bash
   copy "C:\kiro-config-clone\steering\*.md" "C:\Users\<seu-usuario>\.kiro\steering\"
   ```

4. Crie o script de sync em caminho sem espaços:
   ```bash
   mkdir C:\kiro-sync
   copy "C:\kiro-config-clone\sync.bat" C:\kiro-sync\sync.bat
   ```

5. Inicialize o git no `.kiro` e conecte ao remote (veja o guia completo).

6. Reinicie o Kiro.

## Sync automático (Hook)

O hook `Stop` dispara automaticamente após cada execução do agente e chama o `sync.bat`.

**Solução adotada:** o `.bat` fica em `C:\kiro-sync\sync.bat` (caminho sem espaços) e é chamado via:

```
cmd /c "C:\kiro-sync\sync.bat"
```

**Por que não funciona de outras formas:**
- `&&` no comando do hook — o Kiro escapa para `&amp;&amp;` automaticamente
- Caminho com espaços no `.bat` — o CMD quebra no espaço mesmo entre aspas
- `git` sem caminho completo — o Kiro pode não enxergar o PATH do sistema

## Observações

- `settings/mcp.json` está no `.gitignore` pois contém API keys e tokens pessoais
- `settings/mcp.template.json` é a versão segura para versionar
- As steering files são carregadas automaticamente pelo Kiro em todas as sessões
- O `.kiro/` interno (hooks, logs, sessões) também está no `.gitignore`
