output "Workspace_Name" {
    description = "Name of AVD Workspace"
    value = azurerm_virtual_desktop_workspace.ws.name
}

output "Hostpool_Name" {
    description = "Name of HostPool"
    value = azurerm_virtual_desktop_host_pool.hostpool.name
}

output "Application_Group_Name" {
    description = "Name of ApplicationGroup"
    value = azurerm_virtual_desktop_application_group.dag.name
}