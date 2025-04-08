## aws_bedrock_custom_model
output "aws_bedrock_custom_model_id" {
  value = try(aws_bedrock_custom_model.this.*.id)
}

output "aws_bedrock_custom_model_customization_type" {
  value = try(aws_bedrock_custom_model.this.*.customization_type)
}

## aws_bedrock_model_invocation_logging_configuration
output "aws_bedrock_model_invocation_logging_configuration_id" {
  value = try(aws_bedrock_model_invocation_logging_configuration.this.*.id)
}

## aws_bedrock_guardrail
output "aws_bedrock_guardrail_id" {
  value = try(aws_bedrock_guardrail.this.*.id)
}

output "aws_bedrock_guardrail_name" {
  value = try(aws_bedrock_guardrail.this.*.name)
}

## aws_bedrock_provisioned_model_throughput
output "aws_bedrock_provisioned_model_throughput_id" {
  value = try(aws_bedrock_provisioned_model_throughput.this.*.id)
}

output "aws_bedrock_provisioned_model_throughput_commitment_duration" {
  value = try(aws_bedrock_provisioned_model_throughput.this.*.commitment_duration)
}

## aws_bedrockagent_agent
output "aws_bedrockagent_agent_id" {
  value = try(aws_bedrockagent_agent.this.*.id)
}

output "aws_bedrockagent_agent_arn" {
  value = try(aws_bedrockagent_agent.this.*.agent_arn)
}

## aws_bedrockagent_agent_action_group
output "aws_bedrockagent_agent_action_group_id" {
  value = try(aws_bedrockagent_agent_action_group.this.*.id)
}

output "aws_bedrockagent_agent_action_group_name" {
  value = try(aws_bedrockagent_agent_action_group.this.*.action_group_name)
}

## aws_bedrockagent_agent_alias
output "aws_bedrockagent_agent_alias_id" {
  value = try(aws_bedrockagent_agent_alias.this.*.id)
}

output "aws_bedrockagent_agent_alias_name" {
  value = try(aws_bedrockagent_agent_alias.this.*.agent_alias_name)
}

## aws_bedrockagent_agent_knowledge_base_association
output "aws_bedrockagent_agent_knowledge_base_association_id" {
  value = try(aws_bedrockagent_agent_knowledge_base_association.this.*.id)
}

output "aws_bedrockagent_agent_knowledge_base_association_version" {
  value = try(aws_bedrockagent_agent_knowledge_base_association.this.*.agent_version)
}

## aws_bedrockagent_data_source
output "aws_bedrockagent_data_source_id" {
  value = try(aws_bedrockagent_data_source.this.*.id)
}

output "aws_bedrockagent_data_source_name" {
  value = try(aws_bedrockagent_data_source.this.*.name)
}

## aws_bedrockagent_knowledge_base
output "aws_bedrockagent_knowledge_base_id" {
  value = try(aws_bedrockagent_knowledge_base.this.*.id)
}

output "aws_bedrockagent_knowledge_base_arn" {
  value = try(aws_bedrockagent_knowledge_base.this.*.arn)
}
