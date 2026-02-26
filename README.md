# Terraform---IA

## Description

Déploiement d’une VM Ubuntu sur Microsoft Azure avec :

- Terraform (Infrastructure as Code)
- Workspaces `dev` et `prod`
---

## Connexion Azure

```bash
az login
az account show
```

## Terraform

Avant toute chose, veuillez créer un fichier "terraform.tfvars" avec vos propres données à partir du .example  

### Initialisation :
```bash
terraform init
```

### Plan & déploiement :
```bash
terraform plan
terraform apply
```

### Création des workspaces :
```bash
terraform workspace new dev
terraform workspace new prod
```

### Changer de workspace :
```bash
terraform workspace select dev
```

ou

```bash
terraform workspace select prod
```

Pour lister :
```bash
terraform workspace list
```