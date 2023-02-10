variable "create_resource_group" {
  
  default     = false
}

variable "resource_group_name" {
  
  default     = ""
}

variable "location" {
  
  default     = ""
}

variable "iothub_name" {
  type = string
}

variable "sku" {
  type = object({
    name     = string
    capacity = string
  })
}

variable "endpoint" {
  type = object({
    type                       = string
    connection_string          = string
    name                       = string
    batch_frequency_in_seconds = number
    max_chunk_size_in_bytes    = number
    container_name             = string
    encoding                   = string
    file_name_format           = string
  })
}

variable "route" {
    type = object({
        name           = string
        source         = string
        condition      = string
        enabled        = string
    }) 
  }

variable "nrichment" {
  type = object({
    key            = string
    value          = string
  })
}

variable "cloud_to_device" {
  type = object({
    max_delivery_count = number
    default_ttl        = string
  })
}

variable "feedback" {
  type = object({
    time_to_live       = string
    max_delivery_count = number
    lock_duration      = string
  })
}