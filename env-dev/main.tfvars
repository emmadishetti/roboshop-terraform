vpc = {
  main = {
    cidr = "10.0.0.0/18"

    subnets = {
      public = {
        public1 = { cidr = "10.0.0.0/24", az = "us-east-1a" }
        public2 = { cidr = "10.0.1.0/24", az = "us-east-1b" }
      }
      app = {
        app1 = { cidr = "10.0.2.0/24", az = "us-east-1a" }
        app2 = { cidr = "10.0.3.0/24", az = "us-east-1b" }
      }
      db = {
        db1 = { cidr = "10.0.4.0/24", az = "us-east-1a" }
        db2 = { cidr = "10.0.5.0/24", az = "us-east-1b" }

      }
    }
  }
}
default_vpc_id = "vpc-024d1cc2178085b7a"
default_vpc_cidr = "172.31.0.0/16"
default_vpc_route_table_id = "rtb-0934f4cb928bf4950"

tags = {
  company_name  = "ABC Tech"
  business_unit = "Ecommerce"
  project_name  = "roboshop"
  cost_center   = "ecom_rs"
  created_by    = "terraform"
}

env = "dev"
ami = "ami-03265a0778a880afb"
zone_id = "Z009544921RTWVTZ5968R"
ssh_ingress_cidr =  ["172.31.0.202/16"]

alb = {
  public = {
    internal = false
    lb_type  = "application"
    sg_ingress_cidr = ["0.0.0.0/0"]
    sg_port = 80
  }

  private = {
    internal = true
    lb_type  = "application"
    sg_ingress_cidr = ["172.31.0.0/16","10.0.0.0/18" ]
    sg_port = 80
  }
  }
docdb = {
  main = {
    backup_retention_period = 2
    preferred_backup_window = "07:00-09:00"
    skip_final_snapshot = true
    engine_version      = "4.0.0"
    engine_family       = "docdb4.0"
    instance_class      = "db.t3.medium"
    instance_count      = 1
  }
}
rds = {
  main = {
    rds_type                = "mysql"
    db_port                 = 3306
    engine                  = "aurora-mysql"
    engine_family           = "aurora-mysql5.7"
    engine_version          = "5.7.mysql_aurora.2.11.3"
    backup_retention_period = 2
    preferred_backup_window = "07:00-09:00"
    skip_final_snapshot     = true
    instance_class          = "db.t3.small"
    instance_count          = 1
  }
  }
  elasticache = {
    main = {
      elasticache_type            = "redis"
      port                        = 6379
      engine                      = "redis"
      family                      = "redis6.x"
      engine_version              = "6.2"
      node_type                   = "cache.t3.micro"
      num_cache_nodes             = 1

    }
  }

rabbitmq = {
  main = {
    instance_type = "t3.micro"
  }
}

apps = {
  frontend = {
   instance_type = "t3.micro"
    port         = 80
}
}