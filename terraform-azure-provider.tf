terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.43.0"
    }
  }


  backend "azurerm" {
    resource_group_name  = "vipin_devops_resource_group"
    storage_account_name = "vipintfstatestorage"
    container_name       = "tfstate"
    key                  = "X4E3wRQQGKY0mmoURP3/e7nOiF72F19+5VfbKCX7SUkSrbn7LJhmEjj5UWdQCyTGhQRlFWXUeWEE+AStEyvnRw=="
    subscription_id      = "b54b4eeb-e9a6-4f46-b1c1-6f4691cb9b72"
  }
}
  provider "azurerm" {
    features {
    }
    subscription_id = var.subscription_id_value
  }



