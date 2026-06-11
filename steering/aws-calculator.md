---
inclusion: always
---

# Calculadora AWS - Regras

Sempre que o usuário solicitar uma calculadora AWS, ANTES de criar qualquer estimativa, perguntar obrigatoriamente:

1. **Região(ões)**: Em qual(is) região(ões) AWS deseja a estimativa? (ex: us-east-1, sa-east-1, eu-west-1)
2. **Cliente / Ambiente**: Qual é o nome do cliente ou ambiente? (ex: Empresa X, Projeto Y, Dev/QA/Prod)
3. **Modelo de precificação**: Qual modelo de precificação deseja? (ex: On-Demand, Savings Plans 1 ano, Savings Plans 3 anos, Reserved Instances, Spot)

O título da estimativa SEMPRE deve seguir o padrão:
`Calculadora - <nome do cliente> - <Região> - <modelo de precificação>`

Exemplos:
- `Calculadora - Acme Corp - us-east-1 - On-Demand`
- `Calculadora - Projeto X - sa-east-1 - Savings Plans 1 ano`
- `Calculadora - Startup Y - eu-west-1 - Reserved Instances`

Se o usuário solicitar múltiplas regiões, criar uma estimativa separada para cada região seguindo o mesmo padrão de título.
