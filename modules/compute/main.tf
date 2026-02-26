resource "azurerm_service_plan" "sp" {
    name                = "sp-${terraform.workspace}-ocr"
    location            = var.location
    resource_group_name = var.resource_group_name
    os_type             = "Linux"
    sku_name            = "Y1"

    tags = var.tags
}

resource "azurerm_linux_function_app" "func" {
    name                       = "func-${terraform.workspace}-ocr"
    location                   = var.location
    resource_group_name        = var.resource_group_name
    service_plan_id            = azurerm_service_plan.sp.id
    storage_account_name       = var.storage_account_name
    storage_account_access_key = var.storage_account_access_key

    identity {
        type = "SystemAssigned"
    }

    site_config {
        application_stack {
        python_version = "3.10"
        }
    }

    app_settings = {
        "FUNCTIONS_WORKER_RUNTIME" = "python"
        "AzureWebJobsStorage"      = var.storage_connection_string
        "APPINSIGHTS_INSTRUMENTATIONKEY" = var.app_insights_key
        "KEY_VAULT_URI"            = var.keyvault_uri
        "COGNITIVE_ENDPOINT"       = var.cognitive_endpoint
        "VISION_ENDPOINT"          = var.cognitive_endpoint
        "VISION_KEY"               = var.cognitive_key
    }

    tags = var.tags

    depends_on = [
        azurerm_service_plan.sp
    ]
}