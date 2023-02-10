variable "create_resource_group" {
    default = false
  
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "virtual_network_name" {
  type = string
}

variable "subnet_name" {
    type = string
}

variable "public_ip_name" {
  type = string
}

variable "lb_name" {
  type = string
}

variable "lbnatpool" {
    type = object({
        protocol            = string
        frontend_port_start = number
        frontend_port_end   = number
        backend_port        = name
    })
  
}

variable "vmss_name" {
    type = string
}

variable "virtual_machine_size" {
    default     = "Standard_A2_v2"
}

variable "instances_count" {
  default = 2
}

variable "admin_username" {
  type = string
}

variable "os_upgrade_mode" {
  default = "Automatic"
}

variable "availability_zones" {
  default = null
}

variable "storage_profile_image_reference" {
  type = list(object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  }))
}

variable "storage_profile_os_disk" {
  type = object({
    name              = string
    caching           = string
    create_option     = string
    managed_disk_type = string
  })

  default = {
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
}

variable "storage_profile_data_disk" {
  type = object({
    lun           = number
    caching       = string
    create_option = string
    disk_size_gb  = number
  })

  default = {
    caching = "ReadWrite"
    create_option = "Empty"
    disk_size_gb = 10
    lun = 0
  }
}

variable "os_profile" {
    type = object({
        computer_name_prefix = string
    })
}

variable "ssh_keys" {
  type =  object({
    path     = string
    key_data = string
  })
}