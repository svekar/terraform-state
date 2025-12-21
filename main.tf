resource "azurerm_resource_group" "this" {
  location = var.location
  name     = var.resource_group_name
  tags     = var.tags
}

resource "azurerm_storage_account" "this" {
  name                            = var.storage_account_name
  resource_group_name             = azurerm_resource_group.this.name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
  allowed_copy_scope              = "AAD"
  default_to_oauth_authentication = true
  shared_access_key_enabled       = false
}

resource "azurerm_storage_container" "this" {
  name               = var.container_name
  storage_account_id = azurerm_storage_account.this.id
}

resource "azurerm_management_lock" "this" {
  name       = "${azurerm_resource_group.this.name}-lock"
  scope      = azurerm_resource_group.this.id
  lock_level = "CanNotDelete"
  notes      = "This is a management lock to prevent accidental deletion of the resource group."
}

resource "azurerm_log_analytics_workspace" "this" {
  count                        = var.enable_diagnostic_settings ? 1 : 0
  name                         = azurerm_storage_account.this.name
  location                     = var.location
  resource_group_name          = azurerm_resource_group.this.name
  sku                          = "PerGB2018"
  retention_in_days            = 30
  local_authentication_enabled = false
  daily_quota_gb               = 0.1
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  count                      = var.enable_diagnostic_settings ? 1 : 0
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this[0].id
  name                       = "blob_diagnostics"
  target_resource_id = join("", [
    "/subscriptions/${data.azurerm_client_config.current.subscription_id}",
    "/resourceGroups/${azurerm_resource_group.this.name}/providers/",
    "Microsoft.Storage/storageAccounts/${azurerm_storage_account.this.name}/",
    "blobServices/default"
  ])
  enabled_log {
    category_group = "audit"
  }
  enabled_metric {
    category = "Transaction"
  }
}
