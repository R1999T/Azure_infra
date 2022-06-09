terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.91.0"
    }
  }

}

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

//creating azure resource group

//by referencing resource gropu we specify terraform that one resource is dependent on another
resource "azurerm_virtual_network" "rt_vn" {
  name                = "rt-network"
  resource_group_name = azurerm_resource_group.rt-vm.name
  location            = azurerm_resource_group.rt-vm.location
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  tags = {
    environment = "dev"
  }
}
