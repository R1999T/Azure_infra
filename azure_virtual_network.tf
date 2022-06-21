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

//subnet
resource "azurerm_subnet" "rt_subnet" {
  name                 = "rt1_subnet"
  resource_group_name  = azurerm_resource_group.rt_rg.name
  virtual_network_name = azurerm_virtual_network.rt_vn.name
  address_prefixes     = ["10.0.1.0/24"]
}

//azure security group
resource "azurerm_network_security_group" "rt_sg" {
  name                = "rt-sg"
  location            = azurerm_resource_group.rt_rg.location
  resource_group_name = azurerm_resource_group.rt_rg.name

  tags = {
    environment = "dev"
  }

}
//now comes the rules
resource "azurerm_network_security_rule" "rt_dev_rule" {
  name                        = "rt_dev_rule"
  priority                    = 100
  direction                   = "Inbound" //to allow access to our servers
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*" //add your IP address to provide a particular server to access this(try with AWS) 
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rt_rg.name
  network_security_group_name = azurerm_network_security_group.rt_sg.name
}

