module "api_bff_service" {
  source = "git::https://github.com/felipelima5/5dvpr-app-ecs.git?ref=v1.0.0"

  region           = var.region
  application_name = "api_bff_service"
  application_port = 80 # Utilizada na task definition e target group
  ecs_cluster_name = "prd"

  observability = {
    cloudwatch_log_retention_in_days = 5
  }

  # PARÂMETROS TASK DEFINITION
  task_definition = {
    requires_compatibilities                 = "FARGATE"
    network_mode                             = "awsvpc"
    cpu                                      = 256
    memory                                   = 512
    runtime_platform_operating_system_family = "LINUX"
    runtime_platform_cpu_architecture        = "X86_64" # X86_64 / ARM64
  }
  container_definitions = {
    image   = "111109532426.dkr.ecr.us-east-1.amazonaws.com/bff-api-service:latest"
    cpu     = 256
    memory  = 512
    command = ""
  }


  # PARÂMETROS DO SERVIÇO
  service = {
    capacity_provider_fargate        = "FARGATE"
    capacity_provider_fargate_weight = 2 # 50% de peso FARGATE OnDemand

    capacity_provider_fargate_spot        = "FARGATE_SPOT"
    capacity_provider_fargate_spot_weight = 1 # 50% de peso FARGATE Spot

    deployment_minimum_healthy_percent = 100
    deployment_maximum_percent         = 200
    assign_public_ip                   = false
    vpc_id                             = var.vpc_id
    subnets_ids                        = local.subnets
  }

  service_scalling = {
    desired_count                 = 0
    max_capacity                  = 0
    percentual_to_scalling_target = 70
    time_to_scalling_in           = 300
    time_to_scalling_out          = 300
  }


  # PARÂMETROS DO LOADBALANCER
  loadbalancer_application = {
    arn_listener           = "arn:aws:elasticloadbalancing:us-east-1:111109532426:listener/app/5dvpr-alb-api/b99abeb3120c0b19/c4620ac76abf4c8d"
    listener_host_rule     = ["api.keephouseorder.net"]
    listener_paths         = ["/*"]
    priority_rule_listener = 1
    security_group         = ["sg-0afbf789de519c309"] #Security Group do LoadBalancer Application que enviará as requests
  }


  #PARÂMETROS DO TARGET GROUP
  target_group = {
    name                      = "api-service"
    protocol                  = "HTTP"
    protocol_version          = "HTTP1"
    deregistration_delay      = 62
    health_check_path         = "/healthcheck/ready"
    health_check_success_code = "200-499"
  }

  tags = {
    ManagedBy = "IaC"
  }
}












/*
# CRIAÇÃO DO CLUSTER ECS
module "app_bff_ecs_cluster" {
  source = "git::https://github.com/felipelima5/metabase-project-ecs-cluster-module.git?ref=1.0.1"

  ecs_cluster_name               = "5dvpr-${terraform.workspace}"
  logging                        = "OVERRIDE"
  cloud_watch_encryption_enabled = true
  containerInsights              = "enabled"
  tags = {
    env       = "${terraform.workspace}"
    ManagedBy = "IaC"
  }
}

# CRIAÇÃO DO LOAD BALANCER TO TIPO ALB
module "app_bff_alb" {
  source = "git::https://github.com/felipelima5/metabase-project-alb-module.git?ref=1.0.0"

  depends_on = [module.app_bff_ecs_cluster]

  alb_name                   = "alb-metabase"
  internal                   = false
  load_balancer_type         = "application"
  enable_deletion_protection = false
  vpc_id                     = var.vpc_id
  subnets_ids                = local.public_subnets

  enable_create_s3_bucket_log     = false
  bucket_env_name                 = "log-alb-teste-app-module"
  access_logs_prefix              = "log-dev"
  enable_versioning_configuration = "Enabled"

  create_rule_redirect_https = true

  security_group_app_ingress_rules = [
    {
      description     = "Allow Traffic HTTP 443"
      port            = 443
      protocol        = "tcp"
      security_groups = []
      cidr_blocks     = ["0.0.0.0/0"]
    },
    {
      description     = "Allow Traffic HTTP 80"
      port            = 80
      protocol        = "tcp"
      security_groups = []
      cidr_blocks     = ["0.0.0.0/0"]
    }
  ]

  security_group_app_egress_rules = [
    {
      description     = "All Traffic"
      port            = 0
      protocol        = "-1"
      security_groups = []
      cidr_blocks     = ["0.0.0.0/0"]
    }
  ]

  aditional_tags = {
    Env = "Dev"
  }
}

*/


