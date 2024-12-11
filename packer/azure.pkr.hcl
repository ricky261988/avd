source "azure-arm" "windows" {
    client_id = var.client_id
    client_secret = var.client_secret
    subscription_id = var.subscription_id
    tenant_id = var.tenant_id
    managed_image_name = "${var.image_name}-${var.image_version}"
    managed_image_resource_group_name = "PackerImage"
    vm_size = "Standard_D2_v2"
    temp_resource_group_name = "PackerBuild"
    location = "Central India"
    
    os_type = "Windows"
    image_publisher = "MicrosoftWindowsServer"
    image_offer = "WindowsServer"
    image_sku = "2019-Datacenter"

    communicator    = "winrm"
    winrm_use_ssl   = true
    winrm_insecure  = true
    winrm_timeout   = "5m"
    winrm_username  = "packer"
}