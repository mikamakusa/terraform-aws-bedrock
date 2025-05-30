## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.11.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.94.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.94.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kms"></a> [kms](#module\_kms) | ./modules/terraform-aws-kms | n/a |
| <a name="module_s3"></a> [s3](#module\_s3) | ./modules/terraform-aws-s3 | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/terraform-aws-vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_bedrock_custom_model.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrock_custom_model) | resource |
| [aws_bedrock_guardrail.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrock_guardrail) | resource |
| [aws_bedrock_guardrail_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrock_guardrail_version) | resource |
| [aws_bedrock_inference_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrock_inference_profile) | resource |
| [aws_bedrock_model_invocation_logging_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrock_model_invocation_logging_configuration) | resource |
| [aws_bedrock_provisioned_model_throughput.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrock_provisioned_model_throughput) | resource |
| [aws_bedrockagent_agent.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagent_agent) | resource |
| [aws_bedrockagent_agent_action_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagent_agent_action_group) | resource |
| [aws_bedrockagent_agent_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagent_agent_alias) | resource |
| [aws_bedrockagent_agent_knowledge_base_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagent_agent_knowledge_base_association) | resource |
| [aws_bedrockagent_data_source.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagent_data_source) | resource |
| [aws_bedrockagent_knowledge_base.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/bedrockagent_knowledge_base) | resource |
| [aws_bedrock_foundation_model.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/bedrock_foundation_model) | data source |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_default_tags.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eip) | data source |
| [aws_partition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bedrock_custom_model_iam_role"></a> [bedrock\_custom\_model\_iam\_role](#input\_bedrock\_custom\_model\_iam\_role) | n/a | `string` | `null` | no |
| <a name="input_bedrock_custom_model_kms_key_id"></a> [bedrock\_custom\_model\_kms\_key\_id](#input\_bedrock\_custom\_model\_kms\_key\_id) | n/a | `string` | `null` | no |
| <a name="input_bedrock_foundation_model_id"></a> [bedrock\_foundation\_model\_id](#input\_bedrock\_foundation\_model\_id) | n/a | `string` | n/a | yes |
| <a name="input_bedrockagent_agent"></a> [bedrockagent\_agent](#input\_bedrockagent\_agent) | n/a | <pre>list(object({<br/>    id                            = number<br/>    foundation_model              = string<br/>    agent_name                    = optional(string)<br/>    description                   = optional(string)<br/>    idle_session_ttl_in_seconds   = optional(number)<br/>    instruction                   = optional(string)<br/>    prepare_agent                 = optional(bool)<br/>    skip_resource_in_use_check    = optional(bool)<br/>    tags                          = optional(map(string))<br/>    prompt_override_configuration = optional(list(object({<br/>      override_lambda = optional(string)<br/>      prompt_configurations = list(object({<br/>        base_prompt_template = string<br/>        parser_mode          = string<br/>        prompt_creation_mode = string<br/>        prompt_state         = string<br/>        prompt_type          = string<br/>        inference_configuration = list(object({<br/>          max_length     = number<br/>          stop_sequences = list(string)<br/>          temperature    = number<br/>          top_k          = number<br/>          top_p          = number<br/>        }))<br/>      }))<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_bedrockagent_agent_action_group"></a> [bedrockagent\_agent\_action\_group](#input\_bedrockagent\_agent\_action\_group) | n/a | <pre>list(object({<br/>    id                            = number<br/>    agent_id                      = any<br/>    agent_version                 = string<br/>    action_group_name             = string<br/>    action_group_state            = optional(string)<br/>    description                   = optional(string)<br/>    parent_action_group_signature = optional(string)<br/>    skip_resource_in_use_check    = optional(bool)<br/>    action_group_executor = list(object({<br/>      custom_control = optional(string)<br/>      lambda         = optional(string)<br/>    }))<br/>    api_schema = optional(list(object({<br/>      payload = optional(string)<br/>      s3 = optional(list(object({<br/>        s3_bucket_id  = optional(any)<br/>        s3_object_key = optional(string)<br/>      })), [])<br/>    })), [])<br/>    function_schema = optional(list(object({<br/>      member_functions = optional(list(object({<br/>        functions = optional(list(object({<br/>          name        = optional(string)<br/>          description = optional(string)<br/>          parameters = optional(list(object({<br/>            map_block_key = string<br/>            type          = string<br/>            description   = optional(string)<br/>            required      = optional(string)<br/>          })), [])<br/>        })), [])<br/>      })), [])<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_bedrockagent_agent_action_group_lambda"></a> [bedrockagent\_agent\_action\_group\_lambda](#input\_bedrockagent\_agent\_action\_group\_lambda) | n/a | `string` | `null` | no |
| <a name="input_bedrockagent_agent_alias"></a> [bedrockagent\_agent\_alias](#input\_bedrockagent\_agent\_alias) | n/a | <pre>list(object({<br/>    id               = number<br/>    agent_id         = any<br/>    agent_alias_name = string<br/>    description      = optional(string)<br/>    tags             = optional(map(string))<br/>    routing_configuration = optional(list(object({<br/>      agent_version          = optional(string)<br/>      provisioned_throughput = optional(string)<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_bedrockagent_agent_key_arn"></a> [bedrockagent\_agent\_key\_arn](#input\_bedrockagent\_agent\_key\_arn) | n/a | `string` | `null` | no |
| <a name="input_bedrockagent_agent_knowledge_base_association"></a> [bedrockagent\_agent\_knowledge\_base\_association](#input\_bedrockagent\_agent\_knowledge\_base\_association) | n/a | <pre>list(object({<br/>    id                   = number<br/>    description          = string<br/>    agent_id             = any<br/>    knowledge_base_id    = any<br/>    knowledge_base_state = string<br/>    data_deletion_policy = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_bedrockagent_agent_role_arn"></a> [bedrockagent\_agent\_role\_arn](#input\_bedrockagent\_agent\_role\_arn) | n/a | `string` | `null` | no |
| <a name="input_bedrockagent_data_source"></a> [bedrockagent\_data\_source](#input\_bedrockagent\_data\_source) | n/a | <pre>list(object({<br/>    id                = number<br/>    knowledge_base_id = any<br/>    name              = string<br/>    data_source_configuration = list(object({<br/>      type = string<br/>      s3_configuration = optional(list(object({<br/>        bucket_id               = any<br/>        bucket_owner_account_id = optional(string)<br/>        inclusion_prefixes      = optional(list(string))<br/>      })), [])<br/>    }))<br/>    server_side_encryption_configuration = optional(list(object({<br/>      kms_key_arn = optional(string)<br/>    })), [])<br/>    vector_ingestion_configuration = optional(list(object({<br/>      chunking_configuration = optional(list(object({<br/>        chunking_strategy = string<br/>        fixed_size_chunking_configuration = optional(list(object({<br/>          max_tokens         = number<br/>          overlap_percentage = optional(number)<br/>        })), [])<br/>      })), [])<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_bedrockagent_data_source_kms_key"></a> [bedrockagent\_data\_source\_kms\_key](#input\_bedrockagent\_data\_source\_kms\_key) | n/a | `string` | `null` | no |
| <a name="input_bedrockagent_knowledge_base"></a> [bedrockagent\_knowledge\_base](#input\_bedrockagent\_knowledge\_base) | n/a | <pre>list(object({<br/>    id       = number<br/>    role_arn = string<br/>    name     = string<br/>    tags     = optional(map(string))<br/>    knowledge_base_configuration = list(object({<br/>      type = string<br/>      vector_knowledge_base_configuration = optional(list(object({<br/>        embedding_model_arn = string<br/>      })), [])<br/>    }))<br/>    storage_configuration = list(object({<br/>      opensearch_serverless_configuration = optional(list(object({<br/>        vector_index_name = string<br/>        collection_arn    = string<br/>        field_mapping = list(object({<br/>          metadata_field = string<br/>          text_field     = string<br/>          vector_field   = string<br/>        }))<br/>      })), [])<br/>      pinecone_configuration = optional(list(object({<br/>        credentials_secret_arn = string<br/>        connection_string      = string<br/>        field_mapping = list(object({<br/>          metadata_field = string<br/>          text_field     = string<br/>        }))<br/>      })), [])<br/>      rds_configuration = optional(list(object({<br/>        resource_arn           = string<br/>        database_name          = string<br/>        table_name             = string<br/>        credentials_secret_arn = string<br/>        field_mapping = list(object({<br/>          metadata_field    = string<br/>          text_field        = string<br/>          primary_key_field = string<br/>          vector_field      = string<br/>        }))<br/>      })), [])<br/>      redis_enterprise_cloud_configuration = optional(list(object({<br/>        credentials_secret_arn = string<br/>        endpoint               = string<br/>        vector_index_name      = string<br/>        field_mapping = list(object({<br/>          metadata_field = string<br/>          text_field     = string<br/>          vector_field   = string<br/>        }))<br/>      })), [])<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_bedrockagent_knowledge_base_role_arn"></a> [bedrockagent\_knowledge\_base\_role\_arn](#input\_bedrockagent\_knowledge\_base\_role\_arn) | n/a | `string` | `null` | no |
| <a name="input_bucket_policy"></a> [bucket\_policy](#input\_bucket\_policy) | n/a | `any` | `[]` | no |
| <a name="input_custom_model"></a> [custom\_model](#input\_custom\_model) | n/a | <pre>list(object({<br/>    id                      = number<br/>    base_model_identifier   = string<br/>    custom_model_name       = string<br/>    hyperparameters         = map(string)<br/>    role_arn                = string<br/>    job_name                = string<br/>    custom_model_kms_key_id = optional(string)<br/>    customization_type      = optional(string)<br/>    tags                    = optional(map(string))<br/>    output_data_config = list(object({<br/>      s3_uri = string<br/>    }))<br/>    training_data_config = list(object({<br/>      s3_uri        = string<br/>      training_file = string<br/>    }))<br/>    validation_data_config = optional(list(object({<br/>      validator = list(object({<br/>        s3_uri          = string<br/>        validation_file = string<br/>      }))<br/>    })), [])<br/>    vpc_config = optional(list(object({<br/>      security_group_id = any<br/>      subnet_id         = any<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_eip"></a> [eip](#input\_eip) | n/a | `any` | `[]` | no |
| <a name="input_eip_id"></a> [eip\_id](#input\_eip\_id) | n/a | `string` | `null` | no |
| <a name="input_guardrail"></a> [guardrail](#input\_guardrail) | n/a | <pre>list(object({<br/>    id                        = any<br/>    blocked_input_messaging   = string<br/>    blocked_outputs_messaging = string<br/>    name                      = string<br/>    description               = optional(string)<br/>    kms_key_id                = optional(any)<br/>    tags                      = optional(map(string))<br/>    content_policy_config = optional(list(object({<br/>      filters_config = optional(list(object({<br/>        input_strength  = string<br/>        output_strength = string<br/>        type            = string<br/>      })), [])<br/>    })), [])<br/>    contextual_grounding_policy_config = optional(list(object({<br/>      filters_config = optional(list(object({<br/>        threshold = number<br/>        type      = string<br/>      })), [])<br/>    })), [])<br/>    sensitive_information_policy_config = optional(list(object({<br/>      pii_entities_config = optional(list(object({<br/>        action = string<br/>        type   = string<br/>      })), [])<br/>      regexes_config = optional(list(object({<br/>        action  = string<br/>        name    = string<br/>        pattern = string<br/>      })), [])<br/>    })), [])<br/>    topic_policy_config = optional(list(object({<br/>      topics_config = optional(list(object({<br/>        definition = string<br/>        name       = string<br/>        type       = string<br/>      })), [])<br/>    })), [])<br/>    word_policy_config = optional(list(object({<br/>      managed_word_lists_config = optional(list(object({<br/>        type = string<br/>      })), [])<br/>      words_config = optional(list(object({<br/>        text = string<br/>      })), [])<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_guardrail_version"></a> [guardrail\_version](#input\_guardrail\_version) | n/a | <pre>list(object({<br/>    id           = any<br/>    guardrail_id = any<br/>    skip_destroy = optional(bool)<br/>    description  = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_inference_profile"></a> [inference\_profile](#input\_inference\_profile) | n/a | <pre>list(object({<br/>    id          = any<br/>    name        = string<br/>    description = optional(string)<br/>    tags        = optional(map(string))<br/>    model_source = optional(list(object({<br/>      model_name = string<br/>    })), [])<br/>  }))</pre> | n/a | yes |
| <a name="input_kms_key"></a> [kms\_key](#input\_kms\_key) | n/a | `any` | `[]` | no |
| <a name="input_model_invocation_logging_configuration"></a> [model\_invocation\_logging\_configuration](#input\_model\_invocation\_logging\_configuration) | n/a | <pre>list(object({<br/>    id = number<br/>    logging_config = list(object({<br/>      image_data_delivery_enabled     = optional(bool)<br/>      text_data_delivery_enabled      = optional(bool)<br/>      embedding_data_delivery_enabled = optional(bool)<br/>      cloudwatch_config = optional(list(object({<br/>        log_group_name = string<br/>        role_arn       = optional(string)<br/>        large_data_delivery_s3_config = optional(list(object({<br/>          bucket_id  = any<br/>          key_prefix = optional(string)<br/>        })), [])<br/>      })), [])<br/>      s3_config = optional(list(object({<br/>        bucket_id  = any<br/>        key_prefix = optional(string)<br/>      })), [])<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_model_invocation_logging_configuration_log_group"></a> [model\_invocation\_logging\_configuration\_log\_group](#input\_model\_invocation\_logging\_configuration\_log\_group) | n/a | `string` | `null` | no |
| <a name="input_model_invocation_logging_configuration_role"></a> [model\_invocation\_logging\_configuration\_role](#input\_model\_invocation\_logging\_configuration\_role) | n/a | `string` | `null` | no |
| <a name="input_opensearch_collection_arn"></a> [opensearch\_collection\_arn](#input\_opensearch\_collection\_arn) | n/a | `string` | `null` | no |
| <a name="input_pinecone_credentials_secrets_arn"></a> [pinecone\_credentials\_secrets\_arn](#input\_pinecone\_credentials\_secrets\_arn) | n/a | `string` | `null` | no |
| <a name="input_provisioned_model_throughput"></a> [provisioned\_model\_throughput](#input\_provisioned\_model\_throughput) | n/a | <pre>list(object({<br/>    id                     = number<br/>    model_arn              = string<br/>    model_units            = number<br/>    provisioned_model_name = string<br/>    commitment_duration    = optional(string)<br/>    tags                   = optional(map(string))<br/>  }))</pre> | `[]` | no |
| <a name="input_rds_credentials_secret_arn"></a> [rds\_credentials\_secret\_arn](#input\_rds\_credentials\_secret\_arn) | n/a | `string` | `null` | no |
| <a name="input_rds_resource_arn"></a> [rds\_resource\_arn](#input\_rds\_resource\_arn) | n/a | `string` | `null` | no |
| <a name="input_redis_credentials_secret_arn"></a> [redis\_credentials\_secret\_arn](#input\_redis\_credentials\_secret\_arn) | n/a | `string` | `null` | no |
| <a name="input_route_table"></a> [route\_table](#input\_route\_table) | n/a | `any` | `[]` | no |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | n/a | `any` | `[]` | no |
| <a name="input_s3_bucket_server_side_encryption_configuration"></a> [s3\_bucket\_server\_side\_encryption\_configuration](#input\_s3\_bucket\_server\_side\_encryption\_configuration) | n/a | `any` | `[]` | no |
| <a name="input_s3_bucket_versioning"></a> [s3\_bucket\_versioning](#input\_s3\_bucket\_versioning) | n/a | `any` | `[]` | no |
| <a name="input_s3_encryption_kms_master_key_id"></a> [s3\_encryption\_kms\_master\_key\_id](#input\_s3\_encryption\_kms\_master\_key\_id) | n/a | `string` | `null` | no |
| <a name="input_security_group"></a> [security\_group](#input\_security\_group) | n/a | `any` | `[]` | no |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | n/a | `any` | `[]` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | n/a | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | n/a | `any` | `[]` | no |
| <a name="input_vpc_endpoint"></a> [vpc\_endpoint](#input\_vpc\_endpoint) | n/a | `any` | `[]` | no |
| <a name="input_vpc_endpoint_id"></a> [vpc\_endpoint\_id](#input\_vpc\_endpoint\_id) | n/a | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | n/a | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_bedrock_custom_model_customization_type"></a> [aws\_bedrock\_custom\_model\_customization\_type](#output\_aws\_bedrock\_custom\_model\_customization\_type) | n/a |
| <a name="output_aws_bedrock_custom_model_id"></a> [aws\_bedrock\_custom\_model\_id](#output\_aws\_bedrock\_custom\_model\_id) | # aws\_bedrock\_custom\_model |
| <a name="output_aws_bedrock_guardrail_id"></a> [aws\_bedrock\_guardrail\_id](#output\_aws\_bedrock\_guardrail\_id) | # aws\_bedrock\_guardrail |
| <a name="output_aws_bedrock_guardrail_name"></a> [aws\_bedrock\_guardrail\_name](#output\_aws\_bedrock\_guardrail\_name) | n/a |
| <a name="output_aws_bedrock_inference_profile_arn"></a> [aws\_bedrock\_inference\_profile\_arn](#output\_aws\_bedrock\_inference\_profile\_arn) | n/a |
| <a name="output_aws_bedrock_inference_profile_id"></a> [aws\_bedrock\_inference\_profile\_id](#output\_aws\_bedrock\_inference\_profile\_id) | # aws\_bedrock\_inference\_profile |
| <a name="output_aws_bedrock_inference_profile_model_source"></a> [aws\_bedrock\_inference\_profile\_model\_source](#output\_aws\_bedrock\_inference\_profile\_model\_source) | n/a |
| <a name="output_aws_bedrock_inference_profile_name"></a> [aws\_bedrock\_inference\_profile\_name](#output\_aws\_bedrock\_inference\_profile\_name) | n/a |
| <a name="output_aws_bedrock_model_invocation_logging_configuration_id"></a> [aws\_bedrock\_model\_invocation\_logging\_configuration\_id](#output\_aws\_bedrock\_model\_invocation\_logging\_configuration\_id) | # aws\_bedrock\_model\_invocation\_logging\_configuration |
| <a name="output_aws_bedrock_provisioned_model_throughput_commitment_duration"></a> [aws\_bedrock\_provisioned\_model\_throughput\_commitment\_duration](#output\_aws\_bedrock\_provisioned\_model\_throughput\_commitment\_duration) | n/a |
| <a name="output_aws_bedrock_provisioned_model_throughput_id"></a> [aws\_bedrock\_provisioned\_model\_throughput\_id](#output\_aws\_bedrock\_provisioned\_model\_throughput\_id) | # aws\_bedrock\_provisioned\_model\_throughput |
| <a name="output_aws_bedrockagent_agent_action_group_id"></a> [aws\_bedrockagent\_agent\_action\_group\_id](#output\_aws\_bedrockagent\_agent\_action\_group\_id) | # aws\_bedrockagent\_agent\_action\_group |
| <a name="output_aws_bedrockagent_agent_action_group_name"></a> [aws\_bedrockagent\_agent\_action\_group\_name](#output\_aws\_bedrockagent\_agent\_action\_group\_name) | n/a |
| <a name="output_aws_bedrockagent_agent_alias_id"></a> [aws\_bedrockagent\_agent\_alias\_id](#output\_aws\_bedrockagent\_agent\_alias\_id) | # aws\_bedrockagent\_agent\_alias |
| <a name="output_aws_bedrockagent_agent_alias_name"></a> [aws\_bedrockagent\_agent\_alias\_name](#output\_aws\_bedrockagent\_agent\_alias\_name) | n/a |
| <a name="output_aws_bedrockagent_agent_arn"></a> [aws\_bedrockagent\_agent\_arn](#output\_aws\_bedrockagent\_agent\_arn) | n/a |
| <a name="output_aws_bedrockagent_agent_id"></a> [aws\_bedrockagent\_agent\_id](#output\_aws\_bedrockagent\_agent\_id) | # aws\_bedrockagent\_agent |
| <a name="output_aws_bedrockagent_agent_knowledge_base_association_id"></a> [aws\_bedrockagent\_agent\_knowledge\_base\_association\_id](#output\_aws\_bedrockagent\_agent\_knowledge\_base\_association\_id) | # aws\_bedrockagent\_agent\_knowledge\_base\_association |
| <a name="output_aws_bedrockagent_agent_knowledge_base_association_version"></a> [aws\_bedrockagent\_agent\_knowledge\_base\_association\_version](#output\_aws\_bedrockagent\_agent\_knowledge\_base\_association\_version) | n/a |
| <a name="output_aws_bedrockagent_data_source_id"></a> [aws\_bedrockagent\_data\_source\_id](#output\_aws\_bedrockagent\_data\_source\_id) | # aws\_bedrockagent\_data\_source |
| <a name="output_aws_bedrockagent_data_source_name"></a> [aws\_bedrockagent\_data\_source\_name](#output\_aws\_bedrockagent\_data\_source\_name) | n/a |
| <a name="output_aws_bedrockagent_knowledge_base_arn"></a> [aws\_bedrockagent\_knowledge\_base\_arn](#output\_aws\_bedrockagent\_knowledge\_base\_arn) | n/a |
| <a name="output_aws_bedrockagent_knowledge_base_id"></a> [aws\_bedrockagent\_knowledge\_base\_id](#output\_aws\_bedrockagent\_knowledge\_base\_id) | # aws\_bedrockagent\_knowledge\_base |
