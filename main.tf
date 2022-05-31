resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "$schema" = "http://json-schema.org/draft-04/schema#",
        "description" = "Get Queue",
        "properties" = {
            "Queue_Name" = {
                "description" = "Queue_Name",
                "type" = "string"
            }
        },
        "required" = [
            "Queue_Name"
        ],
        "title" = "Get Queue",
        "type" = "object"
    })
    contract_output = jsonencode({
        "$schema" = "http://json-schema.org/draft-04/schema#",
        "description" = "Response",
        "properties" = {
            "QueueID" = {
                "description" = "QueueID",
                "title" = "QueueID",
                "type" = "array"
            }
        },
        "title" = "Response",
        "type" = "object"
    })
    
    config_request {
        request_template     = "$${input.rawRequest}"
        request_type         = "GET"
        request_url_template = "/api/v2/routing/queues?name=$${input.Queue_Name}"
        headers = {
            Content-Type = "application/json"
        }
    }

    config_response {
        success_template = "{\r\n   \"QueueID\": $${Filter1}\r\n}"
        translation_map = { 
            Filter1 = "$.entities[*].id"
        }
    }
}