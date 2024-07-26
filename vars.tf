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
  type = list(object({
    id                  = number
    bucket              = optional(string)
    bucket_prefix       = optional(string)
    force_destroy       = optional(bool)
    object_lock_enabled = optional(bool)
    tags                = optional(map(string))
  }))
  default = []
}

variable "vpc" {
  type = list(object({
    id                                   = number
    cidr_block                           = string
    instance_tenancy                     = optional(string)
    ipv4_ipam_pool_id                    = optional(string)
    ipv4_netmask_length                  = optional(string)
    ipv6_cidr_block                      = optional(string)
    ipv6_cidr_block_network_border_group = optional(string)
    ipv6_ipam_pool_id                    = optional(string)
    ipv6_netmask_length                  = optional(string)
    enable_dns_support                   = optional(bool)
    enable_dns_hostnames                 = optional(bool)
    enable_network_address_usage_metrics = optional(bool)
    assign_generated_ipv6_cidr_block     = optional(bool)
    tags                                 = optional(map(string))
  }))
  default     = {}
  description = <<EOF
EOF
}

variable "vpc_endpoint" {
  type = list(object({
    id                  = number
    service_name        = string
    vpc_id              = optional(number)
    auto_accept         = optional(bool)
    ip_address_type     = optional(string)
    policy              = optional(string)
    private_dns_enabled = optional(bool)
    route_table_ids     = optional(list(number))
    security_group_ids  = optional(list(number))
    subnet_ids          = optional(list(number))
    tags                = optional(map(string))
    vpc_endpoint_type   = optional(string)
    dns_options = optional(list(object({
      dns_record_ip_type                             = optional(string)
      private_dns_only_for_inbound_resolver_endpoint = optional(bool)
    })), [])
    subnet_configuration = optional(list(object({
      ipv4      = optional(string)
      ipv6      = optional(string)
      subnet_id = optional(any)
    })), [])
  }))
  default = []
}

variable "subnet" {
  type = list(object({
    id                                             = number
    vpc_id                                         = optional(number)
    assign_ipv6_address_on_creation                = optional(bool)
    availability_zone                              = optional(string)
    availability_zone_id                           = optional(string)
    cidr_block                                     = optional(string)
    customer_owned_ipv4_pool                       = optional(string)
    enable_dns64                                   = optional(bool)
    enable_lni_at_device_index                     = optional(bool)
    enable_resource_name_dns_a_record_on_launch    = optional(bool)
    enable_resource_name_dns_aaaa_record_on_launch = optional(bool)
    ipv6_cidr_block                                = optional(string)
    ipv6_native                                    = optional(bool)
    map_customer_owned_ip_on_launch                = optional(bool)
    map_public_ip_on_launch                        = optional(bool)
    outpost_arn                                    = optional(string)
    tags                                           = optional(map(string))
  }))
  default     = []
  description = <<EOF
EOF
}

variable "eip" {
  type = list(object({
    id                        = number
    address                   = optional(string)
    associate_with_private_ip = optional(string)
    customer_owned_ipv4_pool  = optional(string)
    domain                    = optional(string)
    instance                  = optional(string)
    network_border_group      = optional(string)
    network_interface         = optional(string)
    public_ipv4_pool          = optional(string)
    tags                      = optional(map(string))
  }))
  default     = []
  description = <<EOF
EOF
}

variable "security_group" {
  type = list(object({
    id                     = number
    egress                 = optional(set(string))
    ingress                = optional(set(string))
    name                   = optional(string)
    name_prefix            = optional(string)
    revoke_rules_on_delete = optional(bool)
    tags                   = optional(map(string))
    vpc_id                 = optional(any)
  }))
  default     = []
  description = <<EOF
EOF
}

variable "route_table" {
  type = list(object({
    id               = number
    vpc_id           = optional(any)
    propagating_vgws = optional(set(string))
    route            = optional(set(string))
    tags             = optional(map(string))
    route = optional(list(object({
      carrier_gateway_id         = optional(string)
      cidr_block                 = optional(string)
      core_network_arn           = optional(string)
      destination_prefix_list_id = optional(string)
      egress_only_gateway_id     = optional(string)
      gateway_id                 = optional(string)
      ipv6_cidr_block            = optional(string)
      local_gateway_id           = optional(string)
      nat_gateway_id             = optional(string)
      network_interface_id       = optional(string)
      transit_gateway_id         = optional(string)
      vpc_endpoint_id            = optional(string)
      vpc_peering_connection_id  = optional(string)
    })), [])
  }))
  default     = []
  description = <<EOF
EOF
}

variable "s3_bucket_versioning" {
  type = list(object({
    id                    = number
    bucket_id             = any
    expected_bucket_owner = optional(string)
    mfa                   = optional(string)
    versioning_configuration = optional(list(object({
      status     = string
      mfa_delete = optional(string)
    })), [])
  }))
  default     = []
  description = <<EOF
EOF
}

variable "s3_bucket_server_side_encryption_configuration" {
  type = list(object({
    id                    = number
    bucket_id             = any
    expected_bucket_owner = optional(string)
    apply_server_side_encryption_by_default = optional(list(object({
      sse_algorithm = string
    })), [])
  }))
}