# ecommerce-infra-common

Infraestrutura Terraform de suporte compartilhada para outros repositórios (pipelines, stages, etc.). Deploy na **conta sandbox Pluralsight**.

## Recursos

- **Bucket S3** `{account_id}stageterraform`: armazena os stages das pipelines de outros repositórios.

## Pipeline CI/CD

### CI (branches `feature/**`)

- Disparo: push em qualquer branch com prefixo `feature/**`
- Ações: `terraform fmt -check`, `terraform validate`, `terraform plan`
- Abre um **PR da branch atual para `sandbox`** (se ainda não existir)

### CD (branch `sandbox`)

- Disparo: push na branch `sandbox` (ex.: merge de um PR) ou execução manual (*workflow_dispatch*)
- Ações: usa credenciais AWS configuradas nos secrets e executa `terraform apply` na conta sandbox

### Credenciais no GitHub (obrigatório para CI plan e CD)

Configure estes **Secrets** no repositório (**Settings → Secrets and variables → Actions**):

| Secret | Descrição | Obrigatório |
|--------|-----------|-------------|
| `AWS_ACCESS_KEY_ID` | Access Key do IAM (conta sandbox Pluralsight) | Sim |
| `AWS_SECRET_ACCESS_KEY` | Secret Access Key do IAM | Sim |
| `AWS_REGION` | Região AWS (ex.: `us-east-1`) | Sim |

Sem esses secrets, o **CI** pode falhar no `terraform plan` e o **CD** não conseguirá fazer deploy na conta correta. Use um usuário IAM com permissão apenas na conta sandbox.

### Fluxo sugerido

1. Criar branch `feature/nome-da-mudanca`
2. Fazer alterações no Terraform e dar push
3. CI roda e abre PR `feature/nome-da-mudanca` → `sandbox`
4. Revisar e fazer merge do PR em `sandbox`
5. CD roda na `sandbox` e aplica o Terraform na conta sandbox

## Uso local

```bash
cd terraform
terraform init
export AWS_ACCESS_KEY_ID=... AWS_SECRET_ACCESS_KEY=... AWS_REGION=...
terraform plan
terraform apply
```

## Estrutura

```
.github/workflows/
  terraform-ci.yml   # CI em feature/** + PR para sandbox
  terraform-cd.yml   # CD em sandbox
terraform/
  main.tf
  variables.tf
  s3-pipeline-stages.tf
  outputs.tf
```
