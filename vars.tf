variable "bedrock_foundation_model_id" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "bedrock_custom_model_iam_role" {
  type    = string
  default = null
}

variable "bedrock_custom_model_kms_key_id" {
  type    = string
  default = null
}

variable "model_invocation_logging_configuration_role" {
  type    = string
  default = null
}

variable "model_invocation_logging_configuration_log_group" {
  type    = string
  default = null
}

variable "vpc_id" {
  type    = string
  default = null
}

variable "eip_id" {
  type    = string
  default = null
}

variable "subnet_id" {
  type    = string
  default = null
}

variable "vpc_endpoint_id" {
  type    = string
  default = null
}

variable "opensearch_collection_arn" {
  type    = string
  default = null
}

variable "pinecone_credentials_secrets_arn" {
  type      = string
  default   = null
  sensitive = true
}

variable "rds_resource_arn" {
  type    = string
  default = null
}

variable "rds_credentials_secret_arn" {
  type      = string
  default   = null
  sensitive = true
}

variable "redis_credentials_secret_arn" {
  type      = string
  default   = null
  sensitive = true
}

variable "bedrockagent_knowledge_base_role_arn" {
  type    = string
  default = null
}

variable "bedrockagent_data_source_kms_key" {
  type    = string
  default = null
}

variable "bedrockagent_agent_role_arn" {
  type    = string
  default = null
}

variable "bedrockagent_agent_key_arn" {
  type    = string
  default = null
}

variable "s3_encryption_kms_master_key_id" {
  type    = string
  default = null
}

variable "bedrockagent_agent_action_group_lambda" {
  type    = string
  default = null
}

variable "custom_model" {
  type = list(object({
    id                      = number
    base_model_identifier   = string
    custom_model_name       = string
    hyperparameters         = map(string)
    role_arn                = string
    job_name                = string
    custom_model_kms_key_id = optional(string)
    customization_type      = optional(string)
    tags                    = optional(map(string))
    output_data_config = list(object({
      s3_uri = string
    }))
    training_data_config = list(object({
      s3_uri        = string
      training_file = string
    }))
    validation_data_config = optional(list(object({
      validator = list(object({
        s3_uri          = string
        validation_file = string
      }))
    })), [])
    vpc_config = optional(list(object({
      security_group_id = any
      subnet_id         = any
    })), [])
  }))
  default     = []
  description = <<EOF
    EOF

  validation {
    condition     = length([for a in var.custom_model : true if contains(["FINE_TUNING", "CONTINUED_PRE_TRAINING"], a.customization_type)]) == length(var.custom_model)
    error_message = "Valid values: FINE_TUNING, CONTINUED_PRE_TRAINING."
  }
}

variable "model_invocation_logging_configuration" {
  type = list(object({
    id = number
    logging_config = list(object({
      image_data_delivery_enabled     = optional(bool)
      text_data_delivery_enabled      = optional(bool)
      embedding_data_delivery_enabled = optional(bool)
      cloudwatch_config = optional(list(object({
        log_group_name = string
        role_arn       = optional(string)
        large_data_delivery_s3_config = optional(list(object({
          bucket_id  = any
          key_prefix = optional(string)
        })), [])
      })), [])
      s3_config = optional(list(object({
        bucket_id  = any
        key_prefix = optional(string)
      })), [])
    }), [])
  }))
  default     = []
  description = <<EOF
    EOF
}

variable "provisioned_model_throughput" {
  type = list(object({
    id                     = number
    model_arn              = string
    model_units            = number
    provisioned_model_name = string
    commitment_duration    = optional(string)
    tags                   = optional(map(string))
  }))
  default     = []
  description = <<EOF
    EOF

  validation {
    condition     = length([for a in var.provisioned_model_throughput : true if contains(["OneMonth", "SixMonths"], a.commitment_duration)]) == length(var.provisioned_model_throughput)
    error_message = "Valid values: OneMonth, SixMonths."
  }
}

variable "guardrail" {
  type = list(object({
    id                        = any
    blocked_input_messaging   = string
    blocked_outputs_messaging = string
    name                      = string
    description               = optional(string)
    kms_key_id                = optional(any)
    tags                      = optional(map(string))
    content_policy_config = optional(list(object({
      filters_config = optional(list(object({
        input_strength  = string
        output_strength = string
        type            = string
      })), [])
    })), [])
    contextual_grounding_policy_config = optional(list(object({
      filters_config = optional(list(object({
        threshold = number
        type      = string
      })), [])
    })), [])
    sensitive_information_policy_config = optional(list(object({
      pii_entities_config = optional(list(object({
        action = string
        type   = string
      })), [])
      regexes_config = optional(list(object({
        action  = string
        name    = string
        pattern = string
      })), [])
    })), [])
    topic_policy_config = optional(list(object({
      topics_config = optional(list(object({
        definition = string
        name       = string
        type       = string
      })), [])
    })), [])
    word_policy_config = optional(list(object({
      managed_word_lists_config = optional(list(object({
        type = string
      })), [])
      words_config = optional(list(object({
        text = string
      })), [])
    })), [])
  }))
  default = []
}

variable "bedrockagent_agent" {
  type = list(object({
    id                            = number
    foundation_model              = string
    agent_name                    = string
    agent_resource_role_arn       = string
    agent_name                    = optional(string)
    agent_resource_role_arn       = optional(string)
    customer_encryption_key_arn   = optional(string)
    description                   = optional(string)
    idle_session_ttl_in_seconds   = optional(number)
    instruction                   = optional(string)
    prepare_agent                 = optional(bool)
    prompt_override_configuration = optional(list(string))
    skip_resource_in_use_check    = optional(bool)
    tags                          = optional(map(string))
    prompt_override_configuration = optional(list(object({
      override_lambda = optional(string)
      prompt_configurations = list(object({
        base_prompt_template = string
        parser_mode          = string
        prompt_creation_mode = string
        prompt_state         = string
        prompt_type          = string
        inference_configuration = list(object({
          max_length     = number
          stop_sequences = list(string)
          temperature    = number
          top_k          = number
          top_p          = number
        }), [])
      }), [])
    })), [])
  }))
  default     = []
  description = <<EOF
    EOF
}

variable "bedrockagent_agent_action_group" {
  type = list(object({
    id                            = number
    agent_id                      = any
    agent_version                 = string
    action_group_name             = string
    action_group_state            = optional(string)
    description                   = optional(string)
    parent_action_group_signature = optional(string)
    skip_resource_in_use_check    = optional(bool)
    action_group_executor = list(object({
      custom_control = optional(string)
      lambda         = optional(string)
    }), [])
    api_schema = optional(list(object({
      payload = optional(string)
      s3 = optional(list(object({
        s3_bucket_id  = optional(any)
        s3_object_key = optional(string)
      })), [])
    })), [])
    function_schema = optional(list(object({
      member_functions = optional(list(object({
        functions = optional(list(object({
          name        = optional(string)
          description = optional(string)
          parameters = optional(list(object({
            map_block_key = string
            type          = string
            description   = optional(string)
            required      = optional(string)
          })), [])
        })), [])
      })), [])
    })), [])
  }))
  default     = []
  description = <<EOF
    EOF
}

variable "bedrockagent_agent_alias" {
  type = list(object({
    id               = number
    agent_id         = any
    agent_alias_name = string
    description      = optional(string)
    tags             = optional(map(string))
    routing_configuration = optional(list(object({
      agent_version          = optional(string)
      provisioned_throughput = optional(string)
    })), [])
  }))
  default     = []
  description = <<EOF
    EOF
}

variable "bedrockagent_agent_knowledge_base_association" {
  type = list(object({
    id                   = number
    description          = string
    agent_id             = any
    knowledge_base_id    = any
    knowledge_base_state = string
    data_deletion_policy = optional(string)
  }))
  default     = []
  description = <<EOF
    EOF
}

variable "bedrockagent_data_source" {
  type = list(object({
    id                = number
    knowledge_base_id = any
    name              = string
    data_source_configuration = list(object({
      type = string
      s3_configuration = optional(list(object({
        bucket_id               = any
        bucket_owner_account_id = optional(string)
        inclusion_prefixes      = optional(list(string))
      })), [])
    }))
    server_side_encryption_configuration = optional(list(object({
      kms_key_arn = optional(string)
    })), [])
    vector_ingestion_configuration = optional(list(object({
      chunking_configuration = optional(list(object({
        chunking_strategy = string
        fixed_size_chunking_configuration = optional(list(object({
          max_tokens         = number
          overlap_percentage = optional(number)
        })), [])
      })), [])
    })), [])
  }))
  default     = []
  description = <<EOF
    EOF
}

variable "bedrockagent_knowledge_base" {
  type = list(object({
    id       = number
    role_arn = string
    name     = string
    tags     = optional(map(string))
    knowledge_base_configuration = list(object({
      type = string
      vector_knowledge_base_configuration = optional(list(object({
        embedding_model_arn = string
      })), [])
    }))
    storage_configuration = list(object({
      opensearch_serverless_configuration = optional(list(object({
        vector_index_name = string
        collection_arn    = string
        field_mapping = list(object({
          metadata_field = string
          text_field     = string
          vector_field   = string
        }))
      })), [])
      pinecone_configuration = optional(list(object({
        credentials_secret_arn = string
        connection_string      = string
        field_mapping = list(object({
          metadata_field = string
          text_field     = string
        }))
      })), [])
      rds_configuration = optional(list(object({
        resource_arn           = string
        database_name          = string
        table_name             = string
        credentials_secret_arn = string
        field_mapping = list(object({
          metadata_field    = string
          text_field        = string
          primary_key_field = string
          vector_field      = string
        }))
      })), [])
      redis_enterprise_cloud_configuration = optional(list(object({
        credentials_secret_arn = string
        endpoint               = string
        vector_index_name      = string
        field_mapping = list(object({
          metadata_field = string
          text_field     = string
          vector_field   = string
        }))
      })), [])
    }))
  }))
  default     = []
  description = <<EOF
    EOF
}

variable "s3_bucket" {
  type    = any
  default = []
}

variable "vpc" {
  type        = any
  default     = []
  description = <<EOF
EOF
}

variable "vpc_endpoint" {
  type    = any
  default = []
}

variable "subnet" {
  type        = any
  default     = []
  description = <<EOF
EOF
}

variable "eip" {
  type        = any
  default     = []
  description = <<EOF
EOF
}

variable "security_group" {
  type        = any
  default     = []
  description = <<EOF
EOF
}

variable "route_table" {
  type        = any
  default     = []
  description = <<EOF
EOF
}

variable "s3_bucket_versioning" {
  type        = any
  default     = []
  description = <<EOF
EOF
}

variable "s3_bucket_server_side_encryption_configuration" {
  type    = any
  default = []
}

variable "kms_key" {
  type    = any
  default = []
}