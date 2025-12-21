
mock_provider "azurerm" {
  alias = "mock"
  override_resource {
    target = azurerm_resource_group.this
  }
  override_resource {
    target = azurerm_storage_account.this
    values = {
      id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.Storage/storageAccounts/storageAccountValue"
    }
  }
  override_resource {
    target = azurerm_storage_container.this
  }
  override_resource {
    target = azurerm_log_analytics_workspace.this
    values = {
      id = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.OperationalInsights/workspaces/workspaceName"
    }
  }
  override_resource {
    target = azurerm_monitor_diagnostic_setting.this
  }
}

run "resource_group_creation" {
  providers = {
    azurerm = azurerm.mock
  }
  command = apply

  assert {
    condition     = azurerm_resource_group.this.name == "${var.resource_group_name}"
    error_message = "Resource group name should be \"${var.resource_group_name}\"."
  }
}


run "storage_account_creation" {
  providers = {
    azurerm = azurerm.mock
  }
  command = apply

  assert {
    condition     = azurerm_storage_account.this.name == "${var.storage_account_name}"
    error_message = "Storage account name should be \"${var.storage_account_name}\"."
  }
}

run "storage_container_creation" {
  providers = {
    azurerm = azurerm.mock
  }
  command = apply

  assert {
    condition     = azurerm_storage_container.this.name == "${var.container_name}"
    error_message = "Container name should be \"${var.container_name}\"."
  }

  assert {
    condition     = azurerm_storage_container.this.storage_account_id == azurerm_storage_account.this.id
    error_message = "Container should be associated with the storage account."
  }
}

run "management_lock_creation" {
  providers = {
    azurerm = azurerm.mock
  }
  command = apply

  assert {
    condition     = azurerm_management_lock.this.lock_level == "CanNotDelete"
    error_message = "Management lock level should be \"CanNotDelete\"."
  }

  assert {
    condition     = azurerm_management_lock.this.scope == azurerm_resource_group.this.id
    error_message = "Management lock scope should match the resource group ID."
  }

}

run "log_analytics_workspace_creation" {
  providers = {
    azurerm = azurerm.mock
  }
  command = apply

  assert {
    condition     = azurerm_log_analytics_workspace.this[0].name == azurerm_storage_account.this.name
    error_message = "Log Analytics workspace name should match the storage account name."
  }

  assert {
    condition     = azurerm_log_analytics_workspace.this[0].resource_group_name == azurerm_resource_group.this.name
    error_message = "Log Analytics workspace should be in the same resource group as the storage account."
  }
}

run "diagnostic_setting_creation" {
  providers = {
    azurerm = azurerm.mock
  }
  command = apply

  assert {
    condition     = azurerm_monitor_diagnostic_setting.this[0].log_analytics_workspace_id == azurerm_log_analytics_workspace.this[0].id
    error_message = "Diagnostic setting should be linked to the Log Analytics workspace."
  }

  assert {
    condition     = azurerm_monitor_diagnostic_setting.this[0].name == "blob_diagnostics"
    error_message = "Diagnostic setting name should be \"blob_diagnostics\"."
  }
}
