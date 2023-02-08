variable "create_resource_group" {
  
  default     = false
}

variable "resource_group_name" {
  
  default     = ""
}

variable "location" {
  
  default     = ""
}

variable "virtual_network_name" {
  
  default     = ""
}



variable "app_gateway_name" {
  
  default     = ""
}


variable "sku" {
  
  type = object({
    name     = string
    tier     = string
    capacity = optional(number)
  })
}

variable "autoscale_configuration" {
  
  type = object({
    min_capacity = number
    max_capacity = optional(number)
  })
  default = null
}

variable "frontend_port" {
  type = number
}


variable "backend_address_pools" {
  
  type = list(object({
    name         = string
    fqdns        = optional(list(string))
    ip_addresses = optional(list(string))
  }))
}

variable "backend_http_settings" {
  
  type = list(object({
    name                                = string
    cookie_based_affinity               = string
    affinity_cookie_name                = optional(string)
    path                                = optional(string)
    enable_https                        = bool
    probe_name                          = optional(string)
    request_timeout                     = number
        
  }))
}

variable "http_listeners" {
  
  type = list(object({
    name                 = string
    host_name            = optional(string)
    host_names           = optional(list(string))
    require_sni          = optional(bool)
    ssl_certificate_name = optional(string)
    firewall_policy_id   = optional(string)
    ssl_profile_name     = optional(string)
    
  }))
}

variable "request_routing_rules" {
  
  type = list(object({
    name                        = string
    rule_type                   = string
    http_listener_name          = string
    backend_address_pool_name   = optional(string)
    backend_http_settings_name  = optional(string)
    redirect_configuration_name = optional(string)
    rewrite_rule_set_name       = optional(string)
    url_path_map_name           = optional(string)
  }))
  default = []
}


variable "ssl_policy" {
  
  type = object({
    disabled_protocols   = optional(list(string))
    policy_type          = optional(string)
    policy_name          = optional(string)
    cipher_suites        = optional(list(string))
    min_protocol_version = optional(string)
  })
  default = null
}

