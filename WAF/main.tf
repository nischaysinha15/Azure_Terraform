resource "azurerm_resource_group" "resource_group" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
}



resource "azurerm_web_application_firewall_policy" "waf" {
  name                = var.waf_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location

  dynamic custom_rules {
    for_each = var.custom_rules
    content ={
    name      = custom_rules.name
    priority  = custom_rules.priority
    rule_type = custom_rules.rule_type

    match_conditions = {
      match_variables = {
        variable_name = custom_rules.match_conditions.variable_name
      }

      operator           = custom_rules.match_conditions.operator
      negation_condition = custom_rules.match_conditions.negation_condition
      match_values       = [custom_rules.match_conditions.match_values]
    }

    action = custom_rules.action
  }

  }
  dynamic policy_settings {
    enabled                     = var.policy_settings.enabled
    mode                        = var.policy_settings.mode
    request_body_check          = var.policy_settings.request_body_check
    file_upload_limit_in_mb     = var.policy_settings.file_upload_limit_in_mb
    max_request_body_size_in_kb = var.policy_settings.max_request_body_size_in_kb
  }

  dynamic managed_rules {
    dynamic exclusion {
        for_each = var.exclusion
        content = {
            match_variable          = exclusion.match_variable
            selector                = exclusion.selector
            selector_match_operator = exclusion.selector_match_operator
        }

    managed_rule_set {
      type    = var.managed_rule_set.type
      version = var.managed_rule_set.version
      rule_group_override {
        rule_group_name = var.rule_group_name
        dynamic rule {
            for_each = var.rule
            content = {
                id      = rule.id
                enabled = rule.enabled
                action  = rule.action
            }
          }
        }
      }
    }
  }
}