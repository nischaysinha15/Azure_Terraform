resource "azurerm_resource_group" "resource_group" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_iothub" "iothub" {
  name                = var.iothub_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location

  sku {
    name     = var.sku.name
    capacity = var.sku.capacity
  }

  dynamic endpoint {
    
    type                       = var.endpoint.type
    connection_string          = var.endpoint.connection_string
    name                       = var.endpoint.name
    batch_frequency_in_seconds = var.endpoint.batch_frequency_in_seconds
    max_chunk_size_in_bytes    = var.endpoint.max_chunk_size_in_bytes
    container_name             = var.endpoint.container_name
    encoding                   = var.endpoint.encoding
    file_name_format           = var.endpoint.file_name_format
  }


  dynamic route {
    name           = var.route.name
    source         = var.route.source
    condition      = var.route.condition
    endpoint_names = var.endpoint.name
    enabled        = var.route.enabled
  }


  dynamic nrichment {
    key            = var.enrichment.key
    value          = var.enrichment.value
    endpoint_names = var.endpoint.name
  }

  dynamic cloud_to_device {
    max_delivery_count = var.cloud_to_device.max_delivery_count
    default_ttl        = var.cloud_to_device.default_ttl
    feedback {
      time_to_live       = var.feedback.time_to_live
      max_delivery_count = var.feedback.max_delivery_count
      lock_duration      = var.feedback.lock_duration
    }
  }

  
}