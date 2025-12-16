
data "azurerm_client_config" "current" {}

import {
  to = azurerm_resource_group.this
  id = join("", [
    "/subscriptions/",
    data.azurerm_client_config.current.subscription_id,
    "/resourceGroups/tfstate",
  ])
}

import {
  to = azurerm_storage_account.this
  id = join("", [
    "/subscriptions/",
    data.azurerm_client_config.current.subscription_id,
    "/resourceGroups/tfstate/providers/Microsoft.Storage/storageAccounts/svejks6tfstate",
  ])
}

import {
  to = azurerm_storage_container.this
  id = join("", [
    "/subscriptions/",
    data.azurerm_client_config.current.subscription_id,
    "/resourceGroups/tfstate/providers/Microsoft.Storage/storageAccounts/svejks6tfstate/blobServices/default/containers/tfstate",
  ])
}

import {
  to = azurerm_log_analytics_workspace.this[0]
  id = join("", [
    "/subscriptions/",
    data.azurerm_client_config.current.subscription_id,
    "/resourceGroups/tfstate/providers/Microsoft.OperationalInsights/workspaces/svejks6tfstate",
  ])
}

import {
  to = azurerm_monitor_diagnostic_setting.this[0]
  id = join("", [
    "/subscriptions/",
    data.azurerm_client_config.current.subscription_id,
    "/resourceGroups/tfstate/providers/Microsoft.Storage/storageAccounts/svejks6tfstate/blobServices/default|blob_diagnostics",
  ])
}
