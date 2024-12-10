module "ResourceGroup" {
    source = "../terarform-modules/ResourceGroup"

    resource_group_name = "TerraformRG"
    resource_group_location = "Central India"
}

module "Workspace" {
    source = "../terarform-modules/Workspace"

    resource_group_name = module.ResourceGroup.azure_terraform_resource_group
    resource_group_location = module.ResourceGroup.azure_terraform_resource_group_location
    workspace_name = "MyWS"
    prefix = "Test"
    hostpool = "Myhostpool"
    expiration = "2024-12-20T12:43:13Z"
    app_group_name = "Myappgroup"
    avd_host_pool_size = 1
    size = "Standard_D2_v2"
    admin_username = "azureuser"
    admin_password = "123@Ricky@@@"
    avd_register = "register-session-host"
    avd_register_session_host_modules_url = "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_02-23-2022.zip"
}
