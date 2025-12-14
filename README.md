# terraform-state
Azure storage account setup as remote state for Terraform

## Overview

This repository deploys a resource group, storage account and blob container
that can be used as an `azurerm` backend for Terraform remote state.

## Usage

Example backend configuration to put in your consuming configuration:

```hcl
terraform {
	backend "azurerm" {
		resource_group_name   = "tfstate"
		storage_account_name  = "svejks6tfstate"
		container_name        = "tfstate"
		key                   = "env.terraform.tfstate"
	}
}
```

You can customize the defaults by providing `var.location`, `var.storage_account_name`,
`var.container_name`, and `var.resource_group_name` when invoking the module.

The `imports.tf` file contains sample import statements used when importing
existing resources into Terraform state — see the file for details.

