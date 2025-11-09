# terraform/variable-auto.tf
# This file can provide example/default values or overrides for testing

aksName         = "vipin-aks-demo"
location        = "eastus2"
resourceGroup   = "vipin-resource-group"
aksNodeCount    = 2
aksNodeVMSize   = "Standard_DS2_v2"
tfBackendRG     = "vipin-demo-tf-rg"
tfBackendStorage = "vipintfstorage"
tfBackendContainer = "tfstate"