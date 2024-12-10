output "azure_terraform_resource_group" {
    description = "Name of Resource Group"
    value = module.ResourceGroup.azure_terraform_resource_group
}

output "azure_terraform_resource_group_location" {
    description = "Name of Resource Group"
    value = module.ResourceGroup.azure_terraform_resource_group_location
}

output "Workspace_Name" {
    description = "Name of AVD Workspace"
    value = module.Workspace.Workspace_Name
}

output "Hostpool_Name" {
    description = "Name of HostPool"
    value = module.Workspace.Hostpool_Name
}

output "Application_Group_Name" {
    description = "Name of ApplicationGroup"
    value = module.Workspace.Application_Group_Name
}