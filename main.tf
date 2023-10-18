
module "vpc" {
  source = "git::https://github.com/emmadishetti/tf-module-vpc.git"

  for_each = var.vpc

  cidr                       = each.value["cidr"]
  subnets                    = each.value["subnets"]
  default_vpc_id             = var.default_vpc_id
  default_vpc_cidr           = var.default_vpc_cidr
  default_vpc_route_table_id = var.default_vpc_route_table_id
  tags                       = var.tags
  env                        = var.env

}


module "alb" {
  source = "git::https://github.com/emmadishetti/tf-module-alb.git"

  for_each = var.alb
  tags                       = var.tags
  env                        = var.env

  lb_type                    = each.value["lb_type"]
  internal                   = each.value["internal"]
  sg_ingress_cidr            = each.value["sg_ingress_cidr"]
  vpc_id                     = each.value["internal"] ? local.vpc_id : var.default_vpc_id
  subnets                    = each.value["internal"] ? local.app_subnets : data.aws_subnets.subnets.ids
  sg_port                    = each.value["sg_port"]

}


module "docdb" {
  source = "git::https://github.com/emmadishetti/tf-module-docdb.git"
  tags   = var.tags
  env    = var.env

  for_each                = var.docdb
  subnet_ids              = local.db_subnets
  backup_retention_period = each.value["backup_retention_period"]
  preferred_backup_window = each.value["preferred_backup_window"]
  skip_final_snapshot     = each.value["skip_final_snapshot"]
  vpc_id                  = local.vpc_id
  sg_ingress_cidr         = local.app_subnets_cidr
  engine_version          = each.value["engine_version"]
  engine_family           = each.value["engine_family"]
  instance_count          = each.value["instance_count"]
  instance_class          = each.value["instance_class"]
}

module "rds" {
  source = "git::https://github.com/emmadishetti/tf-module-rds.git"
  tags   = var.tags
  env    = var.env

  for_each = var.rds

  subnet_ids              = local.db_subnets
  vpc_id                  = local.vpc_id
  sg_ingress_cidr         = local.app_subnets_cidr

  rds_type                = each.value["rds_type"]
  db_port                 = each.value["db_port"]
  engine_family           = each.value["engine_family"]
  engine                  = each.value["engine"]
  engine_version          = each.value["engine_version"]

  backup_retention_period = each.value["backup_retention_period"]
  preferred_backup_window = each.value["preferred_backup_window"]
  skip_final_snapshot     = each.value["skip_final_snapshot"]
  instance_count          = each.value["instance_count"]
  instance_class          = each.value["instance_class"]

}

module "elasticache" {
  source = "git::https://github.com/emmadishetti/tf-module-elasticache.git"
  tags   = var.tags
  env    = var.env

  for_each = var.elasticache

  subnet_ids      = local.db_subnets
  vpc_id          = local.vpc_id
  sg_ingress_cidr = local.app_subnets_cidr

  elasticache_type       = each.value["elasticache_type"]
  port                   = each.value["port"]
  family                 = each.value["family"]
  engine                 = each.value["engine"]
  engine_version         = each.value["engine_version"]
  num_cache_nodes        = each.value["num_cache_nodes"]
  node_type              = each.value["node_type"]

}

module "rabbitmq" {
  source           = "git::https://github.com/emmadishetti/tf-module-rabbitmq.git"
  tags             = var.tags
  env              = var.env
  ami              = var.ami
  zone_id          = var.zone_id
  ssh_ingress_cidr = var.ssh_ingress_cidr

  for_each = var.rabbitmq

  sg_ingress_cidr = local.app_subnets_cidr
  subnet_ids      = local.db_subnets
  vpc_id          = local.vpc_id
  instance_type   = each.value["instance_type"]
}
