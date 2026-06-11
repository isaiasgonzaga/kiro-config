---
inclusion: always
---

# Regras Globais de Diagramas AWS

## Pasta de Output
- Todos os diagramas devem ser salvos em: `C:\Users\Isaias Santos\Desktop\Diagramas AWS Kiro\`
- Formato do arquivo: `<nome-do-diagrama>.drawio`
- NAO copiar nenhum link ou caminho para o clipboard apos salvar

## Labels dos Servicos
- Nome do servico sempre em **negrito** (`fontStyle=1`)
- Cor do texto deve seguir a cor do icone do servico:
  - Route 53, CloudFront, VPC, ALB, NAT Gateway, Internet Gateway -> roxo `#5A30B5`
  - EC2, Lambda, ECS, Fargate -> laranja `#D05C17`
  - RDS, DynamoDB, ElastiCache, Aurora -> azul `#3334B9`
  - S3, EFS, EBS -> verde `#277116`
  - WAF, IAM, ACM, Shield, KMS, Secrets Manager -> vermelho `#C7131F`
  - CloudWatch, CloudTrail -> rosa `#E7157B`
- Posicionar label SEMPRE abaixo do icone, nunca sobre ele (`verticalLabelPosition=bottom;verticalAlign=top`)
- Labels sobre setas: usar `fillColor` igual ao fundo do grupo onde esta para nao tapar a seta

## Icones
- EFS: usar `resIcon=mxgraph.aws4.elastic_file_system` (NAO usar `resIcon=mxgraph.aws4.efs`)
- Nunca usar shapes quebrados

## Layout e Orientacao
- Orientacao: sempre **horizontal** (esquerda para direita)
- Hierarquia obrigatoria dos grupos:
  1. Fundo branco (retangulo branco atras de tudo, maior que o diagrama)
  2. AWS Cloud
  3. AWS Account (para servicos a nivel de conta: CloudTrail, IAM, Billing)
  4. Region
  5. VPC
  6. Availability Zone (AZ-1, AZ-2, etc)
  7. Public Subnet / Private Subnet (dentro de cada AZ)

## Posicionamento Correto dos Servicos por Nivel
- **Nivel global (fora da Region)**: Route 53, CloudFront, WAF, ACM, Shield
- **Nivel de conta (AWS Account)**: CloudTrail, IAM, Billing, Organizations
- **Nivel de Region**: S3, SQS, SNS
- **Nivel de AZ**: ELB/ALB/NLB, NAT Gateway, Internet Gateway
- **Nivel de subnet publica**: Bastion Host, NAT Gateway, Load Balancer
- **Nivel de subnet privada**: EC2, ECS, Lambda, RDS, ElastiCache, EFS

## Agrupamento de Instancias
- Instancias EC2 devem ser agrupadas em containers chamados `EC2 Instances`
- Containers ECS devem ser agrupados em `ECS Cluster`
- Sempre usar o grupo `autoScalingGroup` quando houver escalabilidade

## Fundo Branco
- Sempre inserir um retangulo branco (`fillColor=#FFFFFF;strokeColor=none`) como primeira camada, maior que todos os outros elementos

## Setas
- Estilo padrao: `edgeStyle=orthogonalEdgeStyle;html=1;rounded=1`
- Setas coloridas por protocolo (HTTPS roxo, MySQL/Redis azul, NFS verde, seguranca vermelho)
- Usar `dashed=1` para conexoes secundarias (backup, monitoramento)
- Incluir porta nas setas quando relevante (ex: MySQL 3306, Redis 6379, NFS 2049)

## Qualidade de Apresentacao (C-Level)
- Sempre incluir titulo do diagrama no topo com nome e regiao
- Incluir legenda no rodape
- Fundo levemente colorido por camada para diferenciar os grupos
- Setas com cores distintas por tipo de conexao
- Detalhes tecnicos nas setas (portas, protocolos)