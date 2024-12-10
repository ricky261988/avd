resource "azurerm_virtual_desktop_workspace" "ws" {
    name = var.workspace_name
    resource_group_name = var.resource_group_name
    location = var.resource_group_location
    friendly_name = "${var.prefix}-Workspace"
    description = "${var.prefix}-Workspace"
}

resource "azurerm_virtual_desktop_host_pool" "hostpool" {
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  name                     = var.hostpool
  friendly_name            = var.hostpool
  validate_environment     = true
  start_vm_on_connect      = true
  custom_rdp_properties    = "targetisaadjoined:i:1;drivestoredirect:s:*;audiomode:i:0;videoplaybackmode:i:1;redirectclipboard:i:1;redirectprinters:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;usbdevicestoredirect:s:*;enablecredsspsupport:i:1;redirectwebauthn:i:1;use multimon:i:1;enablerdsaadauth:i:1;"
  description              = "${var.prefix}-HostPool"
  type                     = "Pooled"
  maximum_sessions_allowed = 2
  load_balancer_type       = "DepthFirst"
scheduled_agent_updates {
  enabled = true
  timezone = "India Standard Time"
  schedule {
    day_of_week = "Sunday"
    hour_of_day = 1
  }
}
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "registrationinfo" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.hostpool.id
  expiration_date = var.expiration
}

resource "azurerm_virtual_desktop_application_group" "dag" {
  resource_group_name = var.resource_group_name
  host_pool_id        = azurerm_virtual_desktop_host_pool.hostpool.id
  location            = var.resource_group_location
  type                = "Desktop"
  name                = var.app_group_name
  friendly_name       = var.app_group_name
  description         = "${var.prefix}-AVD application group"
  depends_on          = [azurerm_virtual_desktop_host_pool.hostpool, azurerm_virtual_desktop_workspace.ws]
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "ws-dag" {
  application_group_id = azurerm_virtual_desktop_application_group.dag.id
  workspace_id         = azurerm_virtual_desktop_workspace.ws.id
}

resource "azurerm_network_interface" "wvd_vm1_nic" {
  count               = var.avd_host_pool_size
  name                = "avd-nic-${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  ip_configuration {
    name                          = "TFip"
    subnet_id                     = "/subscriptions/af12fb1e-77d3-4039-83cf-a934a6270fbe/resourceGroups/PackerImage/providers/Microsoft.Network/virtualNetworks/vm1-vnet/subnets/default"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "wvd_vm1" {
  count                 = var.avd_host_pool_size
  name                  = "avd-vm-${count.index}"
  resource_group_name   = var.resource_group_name
  location              = var.resource_group_location
  size                  = var.size
  network_interface_ids = [azurerm_network_interface.wvd_vm1_nic[count.index].id]
  provision_vm_agent    = true
  timezone              = "India Standard Time"
  
  admin_username = var.admin_username
  admin_password = var.admin_password

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_disk {
    name                 = "TFStorage"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  boot_diagnostics {
    storage_account_uri = ""
  }

}

resource "azurerm_virtual_machine_extension" "domain_join" {
  count                      = var.avd_host_pool_size
  name                       = "vmext-AADLoginForWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.wvd_vm1[count.index].id
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}

resource "azurerm_virtual_machine_extension" "avd_register_session_host" {
  count                = var.avd_host_pool_size
  name                 = var.avd_register
  virtual_machine_id   = azurerm_windows_virtual_machine.wvd_vm1[count.index].id
  publisher            = "Microsoft.Powershell"
  type                 = "DSC"
  type_handler_version = "2.73"

  settings = <<-SETTINGS
    {
      "modulesUrl": "${var.avd_register_session_host_modules_url}",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "hostPoolName": "${azurerm_virtual_desktop_host_pool.hostpool.name}",
        "aadJoin": true
      }
    }
    SETTINGS

  protected_settings = <<-PROTECTED_SETTINGS
    {
      "properties": {
        "registrationInfoToken": "${azurerm_virtual_desktop_host_pool_registration_info.registrationinfo.token}"
      }
    }
    PROTECTED_SETTINGS

  lifecycle {
    ignore_changes = [settings, protected_settings]
  }

  depends_on = [azurerm_windows_virtual_machine.wvd_vm1, azurerm_virtual_machine_extension.domain_join]
}