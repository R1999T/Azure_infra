terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      //to modify the version either delete the .terraform.loack.hcl or change the version 
      version = "=2.91.0"
    }
  }

}
//terraform is only interested in provider stuff if you use it wrong its gonna fail
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rt-vm" {
  name     = "rt-resources"
  location = "East Us"
  tags = {
    environment = "dev"
  }
}