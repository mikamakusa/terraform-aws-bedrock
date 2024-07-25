resource "aws_bedrock_custom_model" "this" {
  count                   = length(var.custom_model)
  base_model_identifier   = data.aws_bedrock_foundation_model.this.model_arn
  custom_model_name       = lookup(var.custom_model[count.index], "custom_model_name")
  hyperparameters         = lookup(var.custom_model[count.index], "hyperparameters")
  role_arn                = var.bedrock_custom_model_iam_role
  job_name                = lookup(var.custom_model[count.index], "job_name")
  custom_model_kms_key_id = var.bedrock_custom_model_kms_key_id
  customization_type      = lookup(var.custom_model[count.index], "customization_type")
  tags                    = merge(
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
      subnet_ids         = [
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
              key_prefix  = lookup(large_data_delivery_s3_config.value, "key_prefix")
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
          key_prefix  = lookup(s3_config.value, "key_prefix")
        }
      }
    }
  }
}

resource "aws_bedrock_provisioned_model_throughput" "this" {
  count                  = length(var.provisioned_model_throughput)
  model_arn              = ""
  model_units            = 0
  provisioned_model_name = ""
  commitment_duration    = ""
  tags                   = {}
}

resource "aws_bedrockagent_agent" "this" {
  count                         = length(var.bedrockagent_agent)
  foundation_model              = data.aws_bedrock_foundation_model.this
  agent_name                    = ""
  agent_resource_role_arn       = ""
  customer_encryption_key_arn   = ""
  description                   = ""
  idle_session_ttl_in_seconds   = 0
  instruction                   = ""
  prepare_agent                 = true
  prompt_override_configuration = []
  skip_resource_in_use_check    = true
  tags                          = {}

  dynamic "prompt_override_configuration" {
    for_each = ""
    content {
      override_lambda = ""

      dynamic "prompt_configurations" {
        for_each = ""
        content {
          base_prompt_template = ""
          parser_mode          = ""
          prompt_creation_mode = ""
          prompt_state         = ""
          prompt_type          = ""

          dynamic "inference_configuration" {
            for_each = ""
            content {
              max_length     = 0
              stop_sequences = []
              temperature    = 0
              top_k          = 0
              top_p          = 0
            }
          }
        }
      }
    }
  }
}

resource "aws_bedrockagent_agent_action_group" "this" {
  count             = length(var.bedrockagent_agent_action_group)
  agent_id          = ""
  agent_version     = ""
  action_group_name = ""
  action_group_state = ""
  description = ""
  parent_action_group_signature = ""
  skip_resource_in_use_check = true
  
  dynamic "api_schema" {
    for_each = ""
    content {
      payload = ""
      dynamic "s3" {
        for_each = ""
        content {
          s3_bucket_name = ""
          s3_object_key = ""
        }
      }
    }
  }
  
  dynamic "action_group_executor" {
    for_each = ""
    content {
      custom_control = ""
      lambda = ""
    }
  }

  dynamic "function_schema" {
    for_each = ""
    content {
      dynamic "member_functions" {
        for_each = ""
        content {
          dynamic "functions" {
            for_each = ""
            content {
              name = ""
              description = ""

              dynamic "parameters" {
                for_each = ""
                content {
                  map_block_key = ""
                  type = ""
                  description = ""
                  required = ""
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
  count            = length(var.bedrockagent_agent_alias)
  agent_id         = ""
  agent_alias_name = ""
  description = ""
  tags = {}

  dynamic "routing_configuration" {
    for_each = ""
    content {
      agent_version = ""
      provisioned_throughput = ""
    }
  }
}

resource "aws_bedrockagent_agent_knowledge_base_association" "this" {
  count                = length(var.bedrockagent_agent_knowledge_base_association)
  description          = ""
  agent_id             = ""
  knowledge_base_id    = ""
  knowledge_base_state = ""
  agent_version = ""
}

resource "aws_bedrockagent_data_source" "this" {
  count             = length(var.bedrockagent_data_source)
  knowledge_base_id = ""
  name              = ""
  data_deletion_policy = ""

  dynamic "data_source_configuration" {
    for_each = ""
    content {
      type = ""
      
      dynamic "s3_configuration" {
        for_each = ""
        content {
          bucket_arn = ""
          bucket_owner_account_id = ""
          inclusion_prefixes = [  ]
        }
      }
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = ""
    content {
      kms_key_arn = ""
    }
  }

  dynamic "vector_ingestion_configuration" {
    for_each = ""
    content {
      dynamic "chunking_configuration" {
        for_each = ""
        content {
            chunking_strategy = ""

          dynamic "fixed_size_chunking_configuration" {
            for_each = ""
            content {
              max_tokens = 0
              overlap_percentage = 0
            }
          }
        }
      }
    }
  }
}

resource "aws_bedrockagent_knowledge_base" "this" {
  count    = length(var.bedrockagent_knowledge_base)
  role_arn = ""
  name     = ""
  description = ""
  tags = {}

  dynamic "knowledge_base_configuration" {
    for_each = ""
    content {
      type = ""

      dynamic "vector_knowledge_base_configuration" {
        for_each = ""
        content {
          embedding_model_arn = ""
        }
      }
    }
  }

  dynamic "storage_configuration" {
    for_each = ""
    content {
      type = ""

      dynamic "opensearch_serverless_configuration" {
        for_each = ""
        content {
          vector_index_name = ""
          collection_arn = ""

          dynamic "field_mapping" {
            for_each = ""
            content {
              metadata_field = ""
              text_field = ""
              vector_field = ""
            }
          }
        }
      }

      dynamic "pinecone_configuration" {
        for_each = ""
        content {
          credentials_secret_arn = ""
          connection_string = ""

          dynamic "field_mapping" {
            for_each = ""
            content {
              metadata_field = ""
              text_field = ""
            }
          }
        }
      }

      dynamic "rds_configuration" {
        for_each = ""
        content {
          resource_arn = ""
          database_name = ""
          table_name = ""
          credentials_secret_arn = ""

          dynamic "field_mapping" {
            for_each = ""
            content {
              metadata_field = ""
              text_field = ""
              primary_key_field = ""
              vector_field = ""
            }
          }
        }
      }

      dynamic "redis_enterprise_cloud_configuration" {
        for_each = ""
        content {
          credentials_secret_arn = ""
          endpoint = ""
          vector_index_name = ""

          dynamic "field_mapping" {
            for_each = ""
            content {
              metadata_field = ""
              text_field = ""
              vector_field = ""
            }
          }
        }
      }
    }
  }
}