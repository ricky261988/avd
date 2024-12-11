terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "4.13.0"
        }
        azuread = {
            source = "hashicorp/azuread"
        }
    }
}

provider "azurerm" {
    features {}
}