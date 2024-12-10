output "azure_terraform_resource_group" {
    description = "Name of Resource Group"
    value = azurerm_resource_group.rg.name
}

output "azure_terraform_resource_group_location" {
    description = "Location of Resource Group"
    value = azurerm_resource_group.rg.location
}