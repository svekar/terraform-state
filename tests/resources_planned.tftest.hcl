variables {
  location                   = "swedencentral"
  resource_group_name        = "test-rg"
  storage_account_name       = "teststorageaccount"
  container_name             = "testcontainer"
  enable_diagnostic_settings = true
  prevent_destroy            = true
  tags = {
    Environment = "Test"
    Project     = "Terraform"
  }
}

run "resources_applied" {
  command = plan

  assert {
    condition     = azurerm_resource_group.this.name == var.resource_group_name
    error_message = "Resource group name does not match expected value"
  }
  assert {
    condition     = azurerm_resource_group.this.location == var.location
    error_message = "Resource group location does not match expected value"
  }
  assert {
    condition     = azurerm_resource_group.this.tags == var.tags
    error_message = "Resource group tags do not match expected value"
  }
  assert {
    condition     = azurerm_storage_account.this.name == var.storage_account_name
    error_message = "Storage account name does not match expected value"
  }
  assert {
    condition     = azurerm_storage_account.this.resource_group_name == azurerm_resource_group.this.name
    error_message = "Storage account resource group does not match expected value"
  }
  assert {
    condition     = azurerm_storage_account.this.location == var.location
    error_message = "Storage account location does not match expected value"
  }
  assert {
    condition     = azurerm_storage_account.this.account_tier == "Standard"
    error_message = "Storage account tier does not match expected value"
  }
  assert {
    condition     = azurerm_storage_account.this.account_replication_type == "LRS"
    error_message = "Storage account replication type does not match expected value"
  }
  assert {
    condition     = azurerm_storage_account.this.allow_nested_items_to_be_public == false
    error_message = "Storage account nested items public access does not match expected value"
  }
  assert {
    condition     = azurerm_storage_account.this.allowed_copy_scope == "AAD"
    error_message = "Storage account allowed copy scope does not match expected value"
  }
  assert {
    condition     = azurerm_storage_account.this.default_to_oauth_authentication == true
    error_message = "Storage account OAuth authentication default does not match expected value"
  }
  assert {
    condition     = azurerm_storage_account.this.shared_access_key_enabled == false
    error_message = "Storage account shared access key setting does not match expected value"
  }

  assert {
    condition     = azurerm_storage_container.this.name == var.container_name
    error_message = "Storage container name does not match expected value"
  }
  assert {
    condition     = length(azurerm_management_lock.this) == 1
    error_message = "Management lock should be created when prevent_destroy is true"
  }
  assert {
    condition     = azurerm_management_lock.this[0].name == "${azurerm_resource_group.this.name}-lock"
    error_message = "Management lock name does not match expected value"
  }
  assert {
    condition     = azurerm_management_lock.this[0].lock_level == "CanNotDelete"
    error_message = "Management lock level does not match expected value"
  }
  assert {
    condition     = azurerm_management_lock.this[0].notes == "This is a management lock to prevent accidental deletion of the resource group."
    error_message = "Management lock notes do not match expected value"
  }

  assert {
    condition     = length(azurerm_log_analytics_workspace.this) == 1
    error_message = "Log Analytics workspace should be created when diagnostic settings are enabled"
  }
  assert {
    condition     = azurerm_log_analytics_workspace.this[0].name == azurerm_storage_account.this.name
    error_message = "Log Analytics workspace name does not match expected value"
  }
  assert {
    condition     = azurerm_log_analytics_workspace.this[0].location == var.location
    error_message = "Log Analytics workspace location does not match expected value"
  }
  assert {
    condition     = azurerm_log_analytics_workspace.this[0].resource_group_name == azurerm_resource_group.this.name
    error_message = "Log Analytics workspace resource group does not match expected value"
  }
  assert {
    condition     = azurerm_log_analytics_workspace.this[0].sku == "PerGB2018"
    error_message = "Log Analytics workspace SKU does not match expected value"
  }
  assert {
    condition     = azurerm_log_analytics_workspace.this[0].retention_in_days == 30
    error_message = "Log Analytics workspace retention period does not match expected value"
  }
  assert {
    condition     = azurerm_log_analytics_workspace.this[0].local_authentication_enabled == false
    error_message = "Log Analytics workspace local authentication setting does not match expected value"
  }
  assert {
    condition     = azurerm_log_analytics_workspace.this[0].daily_quota_gb == 0.1
    error_message = "Log Analytics workspace daily quota does not match expected value"
  }
  assert {
    condition     = length(azurerm_monitor_diagnostic_setting.this) == 1
    error_message = "Diagnostic setting should be created when diagnostic settings are enabled"
  }
  assert {
    condition     = azurerm_monitor_diagnostic_setting.this[0].name == "blob_diagnostics"
    error_message = "Diagnostic setting name does not match expected value"
  }
  assert {
    condition     = azurerm_monitor_diagnostic_setting.this[0].target_resource_id == join("", ["/subscriptions/", data.azurerm_client_config.current.subscription_id, "/resourceGroups/", azurerm_resource_group.this.name, "/providers/", "Microsoft.Storage/storageAccounts/", azurerm_storage_account.this.name, "/", "blobServices/default"])
    error_message = "Diagnostic setting target resource ID does not match expected value"
  }
  assert {
    condition     = contains([for entry in azurerm_monitor_diagnostic_setting.this[0].enabled_log : entry.category_group], "audit")
    error_message = "Diagnostic setting enabled log category group does not match expected value"
  }
  assert {
    condition     = contains([for entry in azurerm_monitor_diagnostic_setting.this[0].enabled_metric : entry.category], "Transaction")
    error_message = "Diagnostic setting metric category does not match expected value"
  }
}

run "resources_without_lock" {
  command = plan

  variables {
    prevent_destroy = false
  }

  assert {
    condition     = length(azurerm_management_lock.this) == 0
    error_message = "Management lock should not be created when prevent_destroy is false"
  }
}

run "resources_without_diagnostics" {
  command = plan

  variables {
    enable_diagnostic_settings = false
  }

  assert {
    condition     = length(azurerm_log_analytics_workspace.this) == 0
    error_message = "Log Analytics workspace should not be created when diagnostic settings are disabled"
  }
  assert {
    condition     = length(azurerm_monitor_diagnostic_setting.this) == 0
    error_message = "Diagnostic setting should not be created when diagnostic settings are disabled"
  }
}