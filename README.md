# Terraform-IA - Plateforme OCR sur Azure

Plateforme cloud d'extraction automatique de texte a partir d'images, deployee sur Microsoft Azure avec Terraform.

## Architecture

Le projet utilise une architecture serverless basee sur les services Azure suivants :

| Service | Ressource | Role |
|---------|-----------|------|
| **Resource Group** | `rg-{workspace}` | Conteneur logique de toutes les ressources |
| **Virtual Network** | `vnet` + `subnet` | Isolation reseau (10.0.0.0/16) |
| **Storage Account** | `storageacct{random}` | Stockage des images et resultats OCR |
| **Azure Functions** | `func-{workspace}-ocr` | Traitement serverless declenche par upload blob |
| **Cognitive Service** | `ocrproject-vision` | Azure AI Vision (Computer Vision / OCR) |
| **Key Vault** | `kv-{workspace}-ocrproject` | Gestion securisee des secrets et cles |
| **Application Insights** | `ai-ocrproject` | Monitoring, logs et observabilite |

## Diagramme d'architecture

```
                         +-------------------+
                         |  Upload image     |
                         +--------+----------+
                                  |
                                  v
+------------------+    +-------------------+    +----------------------+
|                  |    |                   |    |                      |
|  Storage Account +--->+  Azure Function   +--->+  Cognitive Service   |
|  (Blob: images/) |    |  (Blob Trigger)   |    |  (Azure AI Vision)   |
|                  |    |  Python 3.10      |    |                      |
+--------+---------+    +--------+----------+    +----------------------+
         |                       |
         |                       v
         |              +-------------------+
         |              |  Application      |
         |              |  Insights         |
         |              |  (Logs/Monitoring) |
         |              +-------------------+
         |
         v
+------------------+    +-------------------+
|  Storage Account |    |                   |
|  (Blob: results/)|    |  Key Vault        |
|  (texte extrait) |    |  (Secrets/Cles)   |
+------------------+    +-------------------+
```

### Flux fonctionnel

1. **Depot** : une image est uploadee dans le container `images/`
2. **Declenchement** : le Blob Trigger de l'Azure Function detecte le nouvel upload
3. **Analyse OCR** : la Function appelle Azure AI Vision pour extraire le texte
4. **Extraction** : le texte est extrait et structure par le service cognitif
5. **Stockage** : le resultat est retourne par la Function

## Structure du projet

```
Terraform-IA/
|-- main.tf                        # Orchestration des modules + provider
|-- variables.tf                   # Variables globales
|-- outputs.tf                     # Outputs du projet
|-- terraform.tfvars               # Valeurs des variables (non versionne)
|-- terraform.tfvars.example       # Exemple de configuration
|-- backend-setup/                 # Configuration du backend distant
|   |-- main.tf
|   |-- variables.tf
|   +-- outputs.tf
|-- modules/
|   |-- network/                   # VNet, Subnet, NSG, IP publique
|   |   |-- main.tf
|   |   |-- variables.tf
|   |   +-- outputs.tf
|   |-- storage/                   # Storage Account + containers blob
|   |   |-- main.tf
|   |   |-- variables.tf
|   |   +-- outputs.tf
|   |-- compute/                   # Function App (serverless)
|   |   |-- main.tf
|   |   |-- variables.tf
|   |   +-- outputs.tf
|   |-- cognitive_service/         # Azure AI Vision (OCR)
|   |   |-- main.tf
|   |   |-- variables.tf
|   |   +-- outputs.tf
|   +-- monitoring/                # Key Vault + Application Insights
|       |-- main.tf
|       |-- variables.tf
|       +-- outputs.tf
+-- function_serverless/           # Code Python de la Function App
    |-- host.json
    |-- requirements.txt
    +-- ocr_function/
        |-- __init__.py            # Script OCR (Blob Trigger)
        +-- function.json          # Configuration du trigger
```

## Modules Terraform

### network
- Virtual Network (`10.0.0.0/16`)
- Subnet (`10.0.1.0/24`)
- Network Security Group (regles SSH, HTTP, Docker)
- IP publique statique

### storage
- Storage Account (Standard LRS, TLS 1.2)
- Container `images/` (acces prive) - depot des images
- Container `results/` (acces prive) - stockage des resultats OCR

### compute
- Service Plan (Consumption Y1, Linux)
- Linux Function App (Python 3.10)
- Managed Identity (SystemAssigned)
- App settings : connexion Storage, App Insights, Cognitive Service

### cognitive_service
- Cognitive Account (ComputerVision, SKU S1)
- Stockage automatique de la cle API dans Key Vault

### monitoring
- Key Vault (SKU standard)
- Access policies pour la gestion des secrets
- Application Insights (retention 30 jours)
- Secrets stockes : cle du Storage Account, cle Cognitive Service

## Securite

| Mesure | Implementation |
|--------|---------------|
| **Managed Identity** | La Function App utilise une identite SystemAssigned |
| **Secrets dans Key Vault** | Cle Cognitive Service et cle Storage stockees dans Key Vault |
| **Containers prives** | Les containers blob `images/` et `results/` sont en acces prive |
| **TLS 1.2** | Version minimale imposee sur le Storage Account |
| **NSG** | Network Security Group avec regles restrictives (SSH limite par IP) |
| **Backend distant** | State Terraform stocke dans Azure Storage avec state locking |
| **Variables sensibles** | `admin_password`, cles d'acces marquees `sensitive` dans Terraform |

## Observabilite

- **Application Insights** : connecte a la Function App via `APPINSIGHTS_INSTRUMENTATIONKEY`
- **Logs OCR** : chaque execution de la Function est tracee (`logging.info`)
- **Monitoring des erreurs** : les exceptions sont capturees automatiquement par App Insights
- **Retention** : 30 jours de conservation des logs

## Cout estime (mensuel)

| Service | SKU | Cout estime |
|---------|-----|-------------|
| **Azure Functions** | Consumption (Y1) | ~0 EUR (1M executions gratuites/mois) |
| **Storage Account** | Standard LRS | ~0.02 EUR/Go |
| **Cognitive Service** | S1 | ~0.844 EUR / 1000 transactions |
| **Key Vault** | Standard | ~0.03 EUR / 10 000 operations |
| **Application Insights** | Gratuit jusqu'a 5 Go/mois | ~0 EUR |
| **Virtual Network** | - | Gratuit |
| **Total estime (dev)** | | **< 5 EUR/mois** (usage faible) |

> Le plan Consumption (Y1) facture uniquement a l'execution. En usage dev/test, le cout est quasi nul.

## Prerequis

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [Azure CLI](https://docs.microsoft.com/fr-fr/cli/azure/install-azure-cli)
- [Azure Functions Core Tools](https://docs.microsoft.com/fr-fr/azure/azure-functions/functions-run-local) v4
- Un abonnement Azure actif

## Deploiement

### 1. Connexion Azure

```bash
az login
az account show
```

### 2. Configuration

Creer un fichier `terraform.tfvars` a partir de l'exemple :

```bash
cp terraform.tfvars.example terraform.tfvars
```

Remplir les valeurs :
- `subscription_id` : ID de l'abonnement Azure
- `allowed_ssh_ip` : IP autorisee pour le SSH
- `admin_password` : mot de passe admin (stocke dans Key Vault)

### 3. Initialisation du backend (premiere fois)

```bash
cd backend-setup
terraform init
terraform apply
cd ..
```

### 4. Deploiement de l'infrastructure

```bash
terraform init
terraform workspace new dev        # ou: terraform workspace select dev
terraform plan
terraform apply
```

### 5. Deploiement de la Function App

```bash
cd function_serverless
func azure functionapp publish func-dev-ocr
```

### 6. Test

Uploader une image dans le container `images/` :

```bash
az storage blob upload \
  --container-name images \
  --account-name <NOM_DU_STORAGE> \
  --file mon_image.png \
  --name mon_image.png
```

Verifier les logs :

```bash
az functionapp function list --name func-dev-ocr --resource-group rg-dev --output table
```

## Workspaces (Environnements)

Le projet supporte les environnements `dev` et `prod` via les Terraform workspaces :

```bash
terraform workspace new dev
terraform workspace new prod
terraform workspace select dev
terraform workspace list
```

Chaque workspace cree des ressources isolees (nommage dynamique : `rg-dev`, `rg-prod`, `func-dev-ocr`, `func-prod-ocr`, etc.).

## Technologies

- **Terraform** v4.61.0 (provider azurerm)
- **Python** 3.10 (Azure Functions)
- **Azure AI Vision** (Computer Vision / OCR)
- **Azure Functions** (Consumption plan, serverless)
