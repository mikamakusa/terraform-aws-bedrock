resource "aws_vpc" "this" {
  count                                = length(var.vpc)
  cidr_block                           = lookup(var.vpc[count.index], "cidr_block")
  instance_tenancy                     = lookup(var.vpc[count.index], "instance_tenancy")
  ipv4_ipam_pool_id                    = lookup(var.vpc[count.index], "ipv4_ipam_pool_id")
  ipv4_netmask_length                  = lookup(var.vpc[count.index], "ipv4_netmask_length")
  ipv6_cidr_block                      = lookup(var.vpc[count.index], "ipv6_cidr_block")
  ipv6_cidr_block_network_border_group = lookup(var.vpc[count.index], "ipv6_cidr_block_network_border_group")
  ipv6_ipam_pool_id                    = lookup(var.vpc[count.index], "ipv6_ipam_pool_id")
  ipv6_netmask_length                  = lookup(var.vpc[count.index], "ipv6_netmask_length")
  enable_dns_support                   = lookup(var.vpc[count.index], "enable_dns_support")
  enable_dns_hostnames                 = lookup(var.vpc[count.index], "enable_dns_hostnames")
  enable_network_address_usage_metrics = lookup(var.vpc[count.index], "enable_network_address_usage_metrics")
  assign_generated_ipv6_cidr_block     = lookup(var.vpc[count.index], "assign_generated_ipv6_cidr_block")
  tags = merge(
    data.aws_default_tags.this.tags,
    var.tags,
    lookup(var.vpc[count.index], "tags")
  )
}

resource "aws_vpc_endpoint" "this" {
  count        = (length(var.vpc) || var.vpc_id != null) == 0 ? 0 : length(var.vpc_endpoint)
  service_name = lookup(var.vpc_endpoint[count.index], "service_name")
  vpc_id = try(
      var.vpc_id != null ? data.aws_vpc.this.id : element(
      aws_vpc.this.*.id, lookup(var.vpc_endpoint[count.index], "vpc_id")
    )
  )
  auto_accept         = lookup(var.vpc_endpoint[count.index], "auto_accept")
  ip_address_type     = lookup(var.vpc_endpoint[count.index], "ip_address_type")
  policy              = lookup(var.vpc_endpoint[count.index], "policy")
  private_dns_enabled = lookup(var.vpc_endpoint[count.index], "private_dns_enabled")
  route_table_ids = try(
      var.route_table_id != null ? [data.aws_route_table.this.route_table_id] : element(
      aws_route_table.this.*.id, lookup(var.vpc_endpoint[count.index], "route_table_ids")
    )
  )
  security_group_ids = try(
      var.security_group_id != null ? [data.aws_security_group.this.id] : element(
      aws_security_group.this.*.id, lookup(var.vpc_endpoint[count.index], "security_group_ids")
    )
  )
  subnet_ids = try(
      var.subnet_id != null ? [data.aws_subnet.this.id] : element(
      aws_subnet.this.*.id, lookup(var.vpc_endpoint[count.index], "subnet_ids")
    )
  )
  tags = merge(
    data.aws_default_tags.this.tags,
    var.tags,
    lookup(var.vpc_endpoint[count.index], "tags")
  )
  vpc_endpoint_type = lookup(var.vpc_endpoint[count.index], "vpc_endpoint_type")

  dynamic "dns_options" {
    for_each = lookup(var.vpc_endpoint[count.index], "dns_options") == null ? [] : ["dns_options"]
    content {
      dns_record_ip_type                             = lookup(dns_options.value, "dns_record_ip_type")
      private_dns_only_for_inbound_resolver_endpoint = lookup(dns_options.value, "private_dns_only_for_inbound_resolver_endpoint")
    }
  }

  dynamic "subnet_configuration" {
    for_each = lookup(var.vpc_endpoint[count.index], "subnet_configuration") == null ? [] : ["subnet_configuration"]
    content {
      ipv4 = lookup(subnet_configuration.value, "ipv4")
      ipv6 = lookup(subnet_configuration.value, "ipv6")
      subnet_id = try(
          var.subnet_id != null ? data.aws_subnet.this.id : element(
          aws_subnet.this.*.id, lookup(subnet_configuration.value, "subnet_id")
        )
      )
    }
  }
}

resource "aws_subnet" "this" {
  count = (length(var.vpc) || var.vpc_id != null) == 0 ? 0 : length(var.subnet)
  vpc_id = try(
      var.vpc_id != null ? data.aws_vpc.this.id : element(
      aws_vpc.this.*.id, lookup(var.subnet[count.index], "vpc_id")
    )
  )
  assign_ipv6_address_on_creation = lookup(var.subnet[count.index], "assign_ipv6_address_on_creation")
  availability_zone               = lookup(var.subnet[count.index], "availability_zone")
  availability_zone_id = try(
    data.aws_availability_zone.this.id
  )
  cidr_block                                     = lookup(var.subnet[count.index], "cidr_block")
  customer_owned_ipv4_pool                       = lookup(var.subnet[count.index], "customer_owned_ipv4_pool")
  enable_dns64                                   = lookup(var.subnet[count.index], "enable_dns64")
  enable_lni_at_device_index                     = lookup(var.subnet[count.index], "enable_lni_at_device_index")
  enable_resource_name_dns_a_record_on_launch    = lookup(var.subnet[count.index], "enable_resource_name_dns_a_record_on_launch")
  enable_resource_name_dns_aaaa_record_on_launch = lookup(var.subnet[count.index], "enable_resource_name_dns_aaaa_record_on_launch")
  ipv6_cidr_block                                = lookup(var.subnet[count.index], "ipv6_cidr_block")
  ipv6_native                                    = lookup(var.subnet[count.index], "ipv6_native")
  map_customer_owned_ip_on_launch                = lookup(var.subnet[count.index], "map_customer_owned_ip_on_launch")
  map_public_ip_on_launch                        = lookup(var.subnet[count.index], "map_public_ip_on_launch")
  outpost_arn                                    = lookup(var.subnet[count.index], "outpost_arn")
  tags = merge(
    data.aws_default_tags.this.tags,
    var.tags,
    lookup(var.subnet[count.index], "tags")
  )
}

resource "aws_eip" "this" {
  count                     = length(var.eip)
  address                   = lookup(var.eip[count.index], "address")
  associate_with_private_ip = lookup(var.eip[count.index], "associate_with_private_ip")
  customer_owned_ipv4_pool  = lookup(var.eip[count.index], "customer_owned_ipv4_pool")
  domain                    = lookup(var.eip[count.index], "domain")
  instance                  = lookup(var.eip[count.index], "instance")
  network_border_group      = lookup(var.eip[count.index], "network_border_group")
  network_interface         = lookup(var.eip[count.index], "network_interface")
  public_ipv4_pool          = lookup(var.eip[count.index], "public_ipv4_pool")
  tags = merge(
    data.aws_default_tags.this.tags,
    var.tags,
    lookup(var.eip[count.index], "tags")
  )
}

resource "aws_security_group" "this" {
  count                  = length(var.security_group)
  egress                 = lookup(var.security_group[count.index], "egress")
  ingress                = lookup(var.security_group[count.index], "ingress")
  name                   = lookup(var.security_group[count.index], "name")
  name_prefix            = lookup(var.security_group[count.index], "name_prefix")
  revoke_rules_on_delete = lookup(var.security_group[count.index], "revoke_rules_on_delete")
  tags = merge(
    data.aws_default_tags.this.tags,
    var.tags,
    lookup(var.security_group[count.index], "tags")
  )
  vpc_id = try(
      var.vpc_id != null ? data.aws_vpc.this.id : element(
      aws_vpc.this.*.id, lookup(var.security_group[count.index], "vpc_id")
    )
  )
}

resource "aws_route_table" "this" {
  count            = (length(var.vpc) || var.vpc_id != null) == 0 ? 0 : length(var.route_table)
  vpc_id           = try(
      var.vpc_id != null ? data.aws_vpc.this.id : element(
      aws_vpc.this.*.id, lookup(var.route_table[count.index], "vpc_id")
    )
  )
  propagating_vgws = lookup(var.route_table[count.index], "propagating_vgws")
  route            = lookup(var.route_table[count.index], "route")
  tags             = merge(
    data.aws_default_tags.this.tags,
    var.tags,
    lookup(var.route_table[count.index], "tags")
  )

  dynamic "route" {
    for_each = lookup(var.route_table[count.index], "route") == null ? [] : ["route"]
    content {
      carrier_gateway_id         = lookup(route.value, "carrier_gateway_id")
      cidr_block                 = lookup(route.value, "cidr_block")
      core_network_arn           = lookup(route.value, "core_network_arn")
      destination_prefix_list_id = lookup(route.value, "destination_prefix_list_id")
      egress_only_gateway_id     = lookup(route.value, "egress_only_gateway_id")
      gateway_id                 = lookup(route.value, "gateway_id")
      ipv6_cidr_block            = lookup(route.value, "ipv6_cidr_block")
      local_gateway_id           = lookup(route.value, "local_gateway_id")
      nat_gateway_id             = lookup(route.value, "nat_gateway_id")
      network_interface_id       = lookup(route.value, "network_interface_id")
      transit_gateway_id         = lookup(route.value, "transit_gateway_id")
      vpc_endpoint_id            = lookup(route.value, "vpc_endpoint_id")
      vpc_peering_connection_id  = lookup(route.value, "vpc_peering_connection_id")
    }
  }
}