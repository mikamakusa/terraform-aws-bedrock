resource "aws_bedrock_custom_model" "this" {
  count                   = length(var.custom_model)
  base_model_identifier   = data.aws_bedrock_foundation_model.this.model_arn
  custom_model_name       = lookup(var.custom_model[count.index], "custom_model_name")
  hyperparameters         = lookup(var.custom_model[count.index], "hyperparameters")
  role_arn                = var.bedrock_custom_model_iam_role
  job_name                = lookup(var.custom_model[count.index], "job_name")
  custom_model_kms_key_id = var.bedrock_custom_model_kms_key_id
  customization_type      = lookup(var.custom_model[count.index], "customization_type")
  tags = merge(
    data.aws_default_tags.this.tags,
    var.tags,
    lookup(var.custom_model[count.index], "tags")
  )

  dynamic "output_data_config" {
    for_each = lookup(var.custom_model[count.index], "output_data_config")
    content {
      s3_uri = join("/", ["s3:/", try(
        element(aws_s3_bucket.this.*.id, lookup(output_data_config.value, "s3_bucket_id"))
      ), "data"])
    }
  }

  dynamic "training_data_config" {
    for_each = lookup(var.custom_model[count.index], "training_data_config")
    content {
      s3_uri = join("/", ["s3:/", try(
        element(aws_s3_bucket.this.*.id, lookup(training_data_config.value, "s3_bucket_id"))
      ), "data", lookup(training_data_config.value, "training_file")])
    }
  }

  dynamic "validation_data_config" {
    for_each = lookup(var.custom_model[count.index], "validation_data_config") == null ? [] : ["validation_data_config"]
    content {
      dynamic "validator" {
        for_each = lookup(validation_data_config.value, "validator")
        content {
          s3_uri = join("/", ["s3:/", try(
            element(aws_s3_bucket.this.*.id, lookup(validation_data_config.value, "s3_bucket_id"))
          ), "data", lookup(validation_data_config.value, "validation_file")])
        }
      }
    }
  }

  dynamic "vpc_config" {
    for_each = lookup(var.custom_model[count.index], "vpc_config") == null ? [] : ["vpc_config"]
    content {
      security_group_ids = [
        try(
          element(aws_security_group.this.*.id, lookup(vpc_config.value, "security_group_id"))
        )
      ]
      subnet_ids = [
        try(
          element(aws_subnet.this.*.id, lookup(vpc_config.value, "subnet_id"))
        )
      ]
    }
  }
}

resource "aws_bedrock_model_invocation_logging_configuration" "this" {
  count = length(var.model_invocation_logging_configuration)

  dynamic "logging_config" {
    for_each = lookup(var.model_invocation_logging_configuration[count.index], "logging_config")
    content {
      image_data_delivery_enabled     = lookup(logging_config.value, "image_data_delivery_enabled")
      text_data_delivery_enabled      = lookup(logging_config.value, "text_data_delivery_enabled")
      embedding_data_delivery_enabled = lookup(logging_config.value, "embedding_data_delivery_enabled")

      dynamic "cloudwatch_config" {
        for_each = lookup(logging_config.value, "cloudwatch_config") == null ? [] : ["cloudwatch_config"]
        content {
          log_group_name = var.model_invocation_logging_configuration_log_group
          role_arn       = var.model_invocation_logging_configuration_role

          dynamic "large_data_delivery_s3_config" {
            for_each = lookup(cloudwatch_config.value, "large_data_delivery_s3_config") == null ? [] : ["large_data_delivery_s3_config"]
            content {
              bucket_name = try(
                element(aws_s3_bucket.this.*.id, lookup(large_data_delivery_s3_config.value, "bucket_id"))
              )
              key_prefix = lookup(large_data_delivery_s3_config.value, "key_prefix")
            }
          }
        }
      }

      dynamic "s3_config" {
        for_each = lookup(logging_config.value, "s3_config") == null ? [] : ["s3_config"]
        content {
          bucket_name = try(
            element(aws_s3_bucket.this.*.id, lookup(s3_config.value, "bucket_id"))
          )
          key_prefix = lookup(s3_config.value, "key_prefix")
        }
      }
    }
  }
}

resource "aws_bedrock_provisioned_model_throughput" "this" {
  count                  = length(var.provisioned_model_throughput)
  model_arn              = data.aws_bedrock_foundation_model.this.model_arn
  model_units            = lookup(var.provisioned_model_throughput[count.index], "model_units")
  provisioned_model_name = lookup(var.provisioned_model_throughput[count.index], "provisioned_model_name")
  commitment_duration    = lookup(var.provisioned_model_throughput[count.index], "commitment_duration")
  tags = merge(
    data.aws_default_tags.this.tags,
    var.tags,
    lookup(var.provisioned_model_throughput[count.index], "tags")
  )
}

resource "aws_bedrockagent_agent" "this" {
  count                         = length(var.bedrockagent_agent)
  foundation_model              = data.aws_bedrock_foundation_model.this
  agent_name                    = lookup(var.bedrockagent_agent[count.index], "agent_name")
  agent_resource_role_arn       = var.bedrockagent_agent_role_arn
  customer_encryption_key_arn   = var.bedrockagent_agent_key_arn
  description                   = lookup(var.bedrockagent_agent[count.index], "description")
  idle_session_ttl_in_seconds   = lookup(var.bedrockagent_agent[count.index], "idle_session_ttl_in_seconds")
  instruction                   = lookup(var.bedrockagent_agent[count.index], "instruction")
  prepare_agent                 = lookup(var.bedrockagent_agent[count.index], "prepare_agent")
  prompt_override_configuration = lookup(var.bedrockagent_agent[count.index], "prompt_override_configuration")
  skip_resource_in_use_check    = lookup(var.bedrockagent_agent[count.index], "skip_resource_in_use_check")
  tags = merge(
    data.aws_default_tags.this.tags,
    var.tags,
    lookup(var.bedrockagent_agent[count.index], "tags")
  )

  dynamic "prompt_override_configuration" {
    for_each = lookup(var.bedrockagent_agent[count.index], "prompt_override_configuration") == null ? [] : ["prompt_override_configuration"]
    content {
      override_lambda = lookup(prompt_override_configuration.value, "override_lambda")

      dynamic "prompt_configurations" {
        for_each = lookup(prompt_override_configuration.value, "prompt_configurations") == null ? [] : ["prompt_configurations"]
        content {
          base_prompt_template = lookup(prompt_configurations.value, "base_prompt_template")
          parser_mode          = lookup(prompt_configurations.value, "parser_mode")
          prompt_creation_mode = lookup(prompt_configurations.value, "prompt_creation_mode")
          prompt_state         = lookup(prompt_configurations.value, "prompt_state")
          prompt_type          = lookup(prompt_configurations.value, "prompt_type")

          dynamic "inference_configuration" {
            for_each = lookup(prompt_configurations.value, "inference_configuration") == null ? [] : ["inference_configuration"]
            content {
              max_length     = lookup(inference_configuration.value, "max_length")
              stop_sequences = lookup(inference_configuration.value, "stop_sequences")
              temperature    = lookup(inference_configuration.value, "temperature")
              top_k          = lookup(inference_configuration.value, "top_k")
              top_p          = lookup(inference_configuration.value, "top_p")
            }
          }
        }
      }
    }
  }
}

resource "aws_bedrockagent_agent_action_group" "this" {
  count                         = length(var.bedrockagent_agent) == 0 ? 0 : length(var.bedrockagent_agent_action_group)
  agent_id                      = try(
    element(aws_bedrockagent_agent.this.*.id, lookup(var.bedrockagent_agent_action_group[count.index], "agent_id"))
  )
  agent_version                 = lookup(var.bedrockagent_agent_action_group[count.index], "agent_version")
  action_group_name             = lookup(var.bedrockagent_agent_action_group[count.index], "action_group_name")
  action_group_state            = lookup(var.bedrockagent_agent_action_group[count.index], "action_group_state")
  description                   = lookup(var.bedrockagent_agent_action_group[count.index], "description")
  parent_action_group_signature = lookup(var.bedrockagent_agent_action_group[count.index], "parent_action_group_signature")
  skip_resource_in_use_check    = lookup(var.bedrockagent_agent_action_group[count.index], "skip_resource_in_use_check")

  dynamic "api_schema" {
    for_each = lookup(var.bedrockagent_agent_action_group[count.index], "api_schema")
    content {
      payload = file(join("/", [path.cwd, "payload", lookup(api_schema.value, "payload")]))

      dynamic "s3" {
        for_each = lookup(api_schema.value, "s3") == null ? [] : ["s3"]
        content {
          s3_bucket_name = try(
            element(aws_s3_bucket.this.*.bucket, lookup(s3.value, "s3_bucket_id"))
          )
          s3_object_key  = lookup(s3.value, "s3_object_key")
        }
      }
    }
  }

  dynamic "action_group_executor" {
    for_each = lookup(var.bedrockagent_agent_action_group[count.index], "action_group_executor") == null ? [] : ["action_group_executor"]
    content {
      custom_control = lookup(action_group_executor.value, "custom_control")
      lambda         = var.bedrockagent_agent_action_group_lambda
    }
  }

  dynamic "function_schema" {
    for_each = lookup(var.bedrockagent_agent_action_group[count.index], "function_schema") == null ? [] : ["function_schema"]
    content {
      dynamic "member_functions" {
        for_each = lookup(function_schema.value, "member_functions") == null ? [] : ["member_functions"]
        content {
          dynamic "functions" {
            for_each = lookup(member_functions.value, "functions") == null ? [] : ["functions"]
            content {
              name        = lookup(functions.value, "name")
              description = lookup(functions.value, "description")

              dynamic "parameters" {
                for_each = lookup(functions.value, "parameters") == null ? [] : ["parameters"]
                content {
                  map_block_key = lookup(parameters.value, "map_block_key")
                  type          = lookup(parameters.value, "type")
                  description   = lookup(parameters.value, "description")
                  required      = lookup(parameters.value, "required")
                }
              }
            }
          }
        }
      }
    }
  }
}

resource "aws_bedrockagent_agent_alias" "this" {
  count            = length(var.bedrockagent_agent) == 0 ? 0 : length(var.bedrockagent_agent_alias)
  agent_id         = try(
    element(aws_bedrockagent_agent.this.*.id, lookup(var.bedrockagent_agent_alias[count.index], "agent_id"))
  )
  agent_alias_name = lookup(var.bedrockagent_agent_alias[count.index], "agent_alias_name")
  description      = lookup(var.bedrockagent_agent_alias[count.index], "description")
  tags             = merge(
    data.aws_default_tags.this.tags,
    var.tags,
    lookup(var.bedrockagent_agent_alias[count.index], "tags")
  )

  dynamic "routing_configuration" {
    for_each = lookup(var.bedrockagent_agent_alias[count.index], "routing_configuration") == null ? [] : ["routing_configuration"]
    content {
      agent_version          = lookup(routing_configuration.value, "agent_version")
      provisioned_throughput = lookup(routing_configuration.value, "provisioned_throughput")
    }
  }
}

resource "aws_bedrockagent_agent_knowledge_base_association" "this" {
  count                = (length(var.bedrockagent_agent) && length(var.bedrockagent_knowledge_base)) == 0 ? 0 : length(var.bedrockagent_agent_knowledge_base_association)
  description          = lookup(var.bedrockagent_agent_knowledge_base_association[count.index], "description")
  agent_id             = try(
    element(aws_bedrockagent_agent.this.*.id, lookup(var.bedrockagent_agent_knowledge_base_association[count.index], "agent_id"))
  )
  knowledge_base_id    = try(
    element(aws_bedrockagent_knowledge_base.this.*.id, lookup(var.bedrockagent_agent_knowledge_base_association[count.index], "knowledge_base_id"))
  )
  knowledge_base_state = lookup(var.bedrockagent_agent_knowledge_base_association[count.index], "knowledge_base_state")
  agent_version        = lookup(var.bedrockagent_agent_knowledge_base_association[count.index], "agent_version")
}

resource "aws_bedrockagent_data_source" "this" {
  count                = length(var.bedrockagent_knowledge_base) == 0 ? 0 : length(var.bedrockagent_data_source)
  knowledge_base_id    = try(
    element(aws_bedrockagent_knowledge_base.this.*.id, lookup(var.bedrockagent_data_source[count.index], "knowledge_base_id"))
  )
  name                 = lookup(var.bedrockagent_data_source[count.index], "name")
  data_deletion_policy = lookup(var.bedrockagent_data_source[count.index], "data_deletion_policy")

  dynamic "data_source_configuration" {
    for_each = lookup(var.bedrockagent_data_source[count.index], "data_source_configuration")
    content {
      type = lookup(data_source_configuration.value, "type")

      dynamic "s3_configuration" {
        for_each = lookup(data_source_configuration.value, "s3_configuration") == null ? [] : ["s3_configuration"]
        content {
          bucket_arn              = try(
            element(aws_s3_bucket.this.*.arn, lookup(s3_configuration.value, "bucket_id"))
          )
        }
      }
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = lookup(var.bedrockagent_data_source[count.index], "server_side_encryption_configuration") == null ? [] : ["server_side_encryption_configuration"]
    content {
      kms_key_arn = var.bedrockagent_data_source_kms_key
    }
  }

  dynamic "vector_ingestion_configuration" {
    for_each = lookup(var.bedrockagent_data_source[count.index], "vector_ingestion_configuration") == null ? [] : ["vector_ingestion_configuration"]
    content {
      dynamic "chunking_configuration" {
        for_each = lookup(vector_ingestion_configuration.value, "chunking_configuration") == null ? [] : ["chunking_configuration"]
        content {
          chunking_strategy = lookup(chunking_configuration.value, "chunking_strategy")

          dynamic "fixed_size_chunking_configuration" {
            for_each = lookup(chunking_configuration.value, "fixed_size_chunking_configuration") == null ? [] : ["fixed_size_chunking_configuration"]
            content {
              max_tokens         = lookup(fixed_size_chunking_configuration.value, "max_tokens")
              overlap_percentage = lookup(fixed_size_chunking_configuration.value, "overlap_percentage")
            }
          }
        }
      }
    }
  }
}

resource "aws_bedrockagent_knowledge_base" "this" {
  count       = length(var.bedrockagent_knowledge_base)
  role_arn    = var.bedrockagent_knowledge_base_role_arn
  name        = lookup(var.bedrockagent_knowledge_base[count.index], "name")
  description = lookup(var.bedrockagent_knowledge_base[count.index], "description")
  tags        = merge(
    data.aws_default_tags.this.tags,
    var.tags,
    lookup(var.bedrockagent_knowledge_base[count.index], "tags")
  )

  dynamic "knowledge_base_configuration" {
    for_each = lookup(var.bedrockagent_knowledge_base[count.index], "knowledge_base_configuration")
    content {
      type = lookup(knowledge_base_configuration.value, "type")

      dynamic "vector_knowledge_base_configuration" {
        for_each = lookup(knowledge_base_configuration.value, "vector_knowledge_base_configuration") == null ? [] : ["vector_knowledge_base_configuration"]
        content {
          embedding_model_arn = data.aws_bedrock_foundation_model.this.model_arn
        }
      }
    }
  }

  dynamic "storage_configuration" {
    for_each = lookup(var.bedrockagent_knowledge_base[count.index], "storage_configuration") == null ? [] : ["storage_configuration"]
    content {
      type = lookup(storage_configuration.value, "type")

      dynamic "opensearch_serverless_configuration" {
        for_each = lookup(storage_configuration.value, "type") == "OPENSEARCH_SERVERLESS" ? lookup(storage_configuration.value, "opensearch_serverless_configuration") : []
        content {
          vector_index_name = lookup(opensearch_serverless_configuration.value, "vector_index_name")
          collection_arn    = var.opensearch_collection_arn

          dynamic "field_mapping" {
            for_each = lookup(opensearch_serverless_configuration.value, "field_mapping") == null ? [] : ["field_mapping"]
            content {
              metadata_field = lookup(field_mapping.value, "metadata_field")
              text_field     = lookup(field_mapping.value, "text_field")
              vector_field   = lookup(field_mapping.value, "vector_field")
            }
          }
        }
      }

      dynamic "pinecone_configuration" {
        for_each = lookup(storage_configuration.value, "type") == "PINECONE" ? lookup(storage_configuration.value, "pinecone_configuration") : []
        content {
          credentials_secret_arn = var.pinecone_credentials_secrets_arn
          connection_string      = lookup(pinecone_configuration.value, "connection_string")

          dynamic "field_mapping" {
            for_each = lookup(pinecone_configuration.value, "field_mapping") == null ? [] : ["field_mapping"]
            content {
              metadata_field = lookup(field_mapping.value, "metadata_field")
              text_field     = lookup(field_mapping.value, "text_field")
            }
          }
        }
      }

      dynamic "rds_configuration" {
        for_each = lookup(storage_configuration.value, "type") == "RDS" ?  lookup(storage_configuration.value, "rds_configuration") : []
        content {
          resource_arn           = var.rds_resource_arn
          database_name          = lookup(rds_configuration.value, "database_name")
          table_name             = lookup(rds_configuration.value, "table_name")
          credentials_secret_arn = var.rds_credentials_secret_arn

          dynamic "field_mapping" {
            for_each = lookup(rds_configuration.value, "field_mapping") == null ? [] : ["field_mapping"]
            content {
              metadata_field    = lookup(field_mapping.value, "metadata_field")
              text_field        = lookup(field_mapping.value, "text_field")
              primary_key_field = lookup(field_mapping.value, "primary_key_field")
              vector_field      = lookup(field_mapping.value, "vector_field")
            }
          }
        }
      }

      dynamic "redis_enterprise_cloud_configuration" {
        for_each = lookup(storage_configuration.value, "type") == "REDIS_ENTERPRISE_CLOUD" ? lookup(storage_configuration.value, "redis_enterprise_cloud_configuration") : []
        content {
          credentials_secret_arn = var.redis_credentials_secret_arn
          endpoint               = lookup(redis_enterprise_cloud_configuration.value, "endpoint")
          vector_index_name      = lookup(redis_enterprise_cloud_configuration.value, "vector_index_name")

          dynamic "field_mapping" {
            for_each = lookup(redis_enterprise_cloud_configuration.value, "field_mapping") == null ? [] : ["field_mapping"]
            content {
              metadata_field = lookup(field_mapping.value, "metadata_field")
              text_field     = lookup(field_mapping.value, "text_field")
              vector_field   = lookup(field_mapping.value, "vector_field")
            }
          }
        }
      }
    }
  }
}