variable "create_resource_group" {
  
  default     = false
}

variable "resource_group_name" {
  
  default     = ""
}

variable "location" {
  
  default     = ""
}

variable "waf_name" {
  type = string
}

variable "custom_rules" {
  type = list(object({
    name      = string
    priority  = string
    rule_type = string
    action    = string
    match_conditions = {
        variable_name = string
        operator           = string
        negation_condition = string
        match_values       = list
    }
  }))
}

variable "policy_settings" {
  type = object({
    enabled                     = bool
    mode                        = string
    request_body_check          = string
    file_upload_limit_in_mb     = string
    max_request_body_size_in_kb = string
  })
}

variable "exclusion" {
  type = list(object({
    match_variable          = string
    selector                = string
    selector_match_operator = string
  }))
}

variable "managed_rule_set" {
  type = object({
    type    = string
    version = string
  })
}

variable "rule_group_name" {
  type = string
}

variable "rule" {
  type = list(object({
    id      = string
    enabled = bool
    action  = string
  }))
}