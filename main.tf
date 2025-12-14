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
