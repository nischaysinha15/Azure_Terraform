resource "azurerm_resource_group" "resource_group" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  address_space       = ["192.168.0.0/16"]
}
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.0.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Static"
  
}

resource "azurerm_lb" "lb" {
  name                = var.lb_name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  resource_group_name = azurerm_resource_group.resource_group.name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_nat_pool" "lbnatpool" {
  resource_group_name            = azurerm_resource_group.resource_group.name
  name                           = "ssh"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = var.lbnatpool.protocol
  frontend_port_start            = var.lbnatpool.frontend_port_start
  frontend_port_end              = var.lbnatpool.frontend_port_end
  backend_port                   = var.lbnatpool.backend_port
  frontend_ip_configuration_name = "PublicIPAddress"
}


resource "azurerm_linux_virtual_machine_scale_set" "vmss_linux" {
  
  name                                              = var.vmss_name
  resource_group_name                               = azurerm_resource_group.resource_group.name
  location                                          = azurerm_resource_group.resource_group.location
  sku                                               = var.virtual_machine_size
  instances                                         = var.instances_count
  admin_username                                    = var.admin_username
  upgrade_mode                                      = var.os_upgrade_mode
  zones                                             = var.availability_zones
  

  dynamic storage_profile_image_reference {
    for_each = var.storage_profile_image_reference
    content {
    publisher = storage_profile_image_reference.value.publisher
    offer     = storage_profile_image_reference.value.offer
    sku       = storage_profile_image_reference.value.sku
    version   = storage_profile_image_reference.value.version
  }
  }
  dynamic storage_profile_os_disk {
    
    name              = storage_profile_os_disk.value.name
    caching           = storage_profile_os_disk.value.caching
    create_option     = storage_profile_os_disk.value.create_option
    managed_disk_type = storage_profile_os_disk.value.managed_disk_type
    
  }

  dynamic storage_profile_data_disk {
    
    lun           = storage_profile_data_disk.value.lun
    caching       = storage_profile_data_disk.value.caching
    create_option = storage_profile_data_disk.value.create_option
    disk_size_gb  = storage_profile_data_disk.value.disk_size_gb
    
  }

  os_profile {
    computer_name_prefix = var.os_profile.computer_name_prefix
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = var.ssh_keys.path
      key_data = var.ssh_keys.key_data
    }
  }

  network_profile {
    name    = "vmss_linux_network_profile"
    primary = true

    ip_configuration {
      name                                   = "vmss_ip_configuration"
      primary                                = true
      subnet_id                              = azurerm_subnet.subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id]
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.lbnatpool.id]
    }
  }

}