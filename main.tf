module "AzureVirtualDesktop" {
    source = "./terraform-modules/AzureVirtualDesktop"

    resource_group_name = "TerraformRG"
    resource_group_location = "Central India"
    workspace_name = "MyWS"
    prefix = "Test"
    hostpool = "Myhostpool"
    expiration = "2024-12-20T12:43:13Z"
    app_group_name = "Myappgroup"
    avd_host_pool_size = 1
    size = "Standard_D2_v2"
    admin_username = "azureuser"
    admin_password = "123@Ricky@@@"
    avd_register = "sessionhost"
    avd_register_session_host_modules_url = "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_1.0.02872.560.zip"
}
