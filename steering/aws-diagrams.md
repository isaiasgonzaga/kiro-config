---
inclusion: always
---

# Regras Globais de Diagramas AWS

## Pasta de Output
- Todos os diagramas devem ser salvos em: `C:\Users\Isaias Santos\Desktop\Diagramas AWS Kiro\`
- Formato do arquivo: `<nome-do-diagrama>.drawio`
- NAO copiar nenhum link ou caminho para o clipboard apos salvar
- NAO abrir o diagrama no navegador — apenas salvar o arquivo .drawio usando `mcp_drawio_aws_save_diagram`

## Labels dos Servicos
- Nome do servico sempre em negrito (fontStyle=1)
- Cor do texto deve seguir a cor do icone do servico:
  - Route 53, CloudFront, VPC, ALB, NAT Gateway, Internet Gateway -> roxo #5A30B5
  - EC2, Lambda, ECS, Fargate -> laranja #D05C17
  - RDS, DynamoDB, ElastiCache, Aurora -> azul #3334B9
  - S3, EFS, EBS -> verde #277116
  - WAF, IAM, ACM, Shield, KMS, Secrets Manager -> vermelho #C7131F
  - CloudWatch, CloudTrail, SNS -> rosa #E7157B
- Posicionar label SEMPRE abaixo do icone, nunca sobre ele (verticalLabelPosition=bottom;verticalAlign=top)

## Icones
- EFS: usar resIcon=mxgraph.aws4.elastic_file_system (NAO usar resIcon=mxgraph.aws4.efs)
- Tamanho padrao dos icones: 56x56

## Layout e Orientacao
- Orientacao: horizontal com fluxo vertical dentro das subnets (compute em cima, database embaixo)
- Hierarquia obrigatoria dos grupos:
  1. Fundo branco (retangulo branco atras de tudo, maior que o diagrama)
  2. AWS Cloud
  3. Region
  4. VPC
  5. Availability Zone
  6. Public Subnet / Private Subnet (dentro de cada AZ)
- Grupos com tamanho ajustado ao conteudo — sem espacos vazios internos
- Grupos tematicos fora da VPC (Storage, Security, Monitoring) compactos e alinhados

## Posicionamento Correto dos Servicos por Nivel
- Nivel global (fora da Region): Route 53, CloudFront, WAF, ACM, Shield
- Nivel de conta (AWS Account): CloudTrail, IAM, Billing, Organizations
- Nivel de Region: S3, SQS, SNS
- Nivel de AZ: ELB/ALB/NLB, NAT Gateway, Internet Gateway
- Nivel de subnet publica: Bastion Host, NAT Gateway, Load Balancer
- Nivel de subnet privada: EC2, ECS, Lambda, RDS, ElastiCache, EFS

## Agrupamento de Instancias
- Instancias EC2 devem ser agrupadas em containers chamados EC2 Instances
- Sempre usar grupos tematicos com borda tracejada e label (ex: Compute component, Database component)

## Fundo Branco
- Sempre inserir um retangulo branco (fillColor=#FFFFFF;strokeColor=none) como primeira camada, maior que todos os outros elementos

## Setas
- Estilo padrao: edgeStyle=orthogonalEdgeStyle;html=1;rounded=1
- Setas coloridas por protocolo (HTTPS roxo, MySQL/Redis azul, NFS verde, seguranca vermelho)
- Usar dashed=1 para conexoes secundarias (backup, monitoramento, SSL)
- Incluir porta nas setas quando relevante (ex: MySQL 3306, Redis 6379, NFS 2049)

## Qualidade de Apresentacao (C-Level)
- Simetria: todos os elementos alinhados em grid consistente, sem sobreposicao de texto
- Grupos sem espacos desperdicados
- Fundo levemente colorido nas subnets para diferenciar Public (verde claro) e Private (azul claro)
- Grupos tematicos externos com borda tracejada fina sem fill
## MCP a Utilizar
- Para criar diagramas: usar APENAS `mcp_drawio_official_open_drawio_xml` (gerar XML completo) e `mcp_drawio_aws_save_diagram` (salvar arquivo)
- NAO usar mcp_drawio_aws_insert_vertex, mcp_drawio_aws_insert_library_shape, mcp_drawio_aws_list_shapes, mcp_drawio_aws_search_shapes, mcp_drawio_aws_list_categories ou qualquer outro mcp_drawio_aws_* para construir o diagrama peça por peça
- Os shapes dos icones AWS devem ser escritos diretamente no XML usando os styles conhecidos

## Icones AWS — Nao Alterar
- Nunca trocar os icones AWS solicitados pelo usuario — se o usuario pediu EC2, usar EC2; se pediu RDS, usar RDS
- Apenas corrigir icones que estao visivelmente quebrados (ex: EFS usa elastic_file_system)