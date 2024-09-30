
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



module "app_bff_service" {
  source = "git::git::git@github.com:aws-iac-tf-modules/app_ecs.git?ref=v1.0.1"

  env              = "dev"
  region           = var.region
  application_name = "service-api"
  application_port = 80   # Porta da Aplicação será usada para a task Definition e target Group

  cloudwatch_log_retention_in_days = 3

  # PARÂMETROS TASK DEFINITION
  requires_compatibilities                 = "FARGATE"
  network_mode                             = "awsvpc"
  cpu                                      = 256
  memory                                   = 512
  runtime_platform_operating_system_family = "LINUX"
  runtime_platform_cpu_architecture        = "X86_64" #---------- X86_64 ou ARM64
  container_definitions_image              = "nginx:latest"
  container_definitions_cpu                = 256
  container_definitions_memory             = 512
  container_definitions_memory_reservation = 256  # -------------- Soft Limit
  container_definitions_command            = ""   # No seguinte formato "nodejs,start"

  # PARÂMETROS DO SERVIÇO
  ecs_cluster_name              = "ecs-cluster"
  service_desired_count         = 1 
  scalling_max_capacity         = 2
  percentual_to_scalling_target = 70
  time_to_scalling_in           = 300
  time_to_scalling_out          = 300

  capacity_provider_fargate        = "FARGATE"
  capacity_provider_fargate_weight = 2 # 50% de peso FARGATE OnDemand

  capacity_provider_fargate_spot        = "FARGATE_SPOT"
  capacity_provider_fargate_spot_weight = 1 # 50% de peso FARGATE Spot

  service_deployment_minimum_healthy_percent = 100
  service_deployment_maximum_percent         = 200
  service_assign_public_ip                   = false
  vpc_id                                     = var.vpc_id
  subnets_ids                                = local.subnets

  
  #Load Balancer
  arn_listener_alb             = "arn:aws:elasticloadbalancing:us-east-1:xxxxxxxxxxx:listener/app/alb-dev/345bd28b5164f1ce/b234dce486a6f68d"
  alb_listener_host_rule       = "app.domain.com.br"
  priority_rule_listener       = 1

  # LoadBalancer TargetGroup
  target_protocol                  = "HTTP"
  target_protocol_version          = "HTTP1"
  target_deregistration_delay      = 10
  target_health_check_path         = "/healthcheck/ready"
  target_health_check_success_code = "200-499"

  security_group_alb = ["sg-xxxxxxxxxxxxxxx"] #Security Group do LoadBalancer Application que enviará as requests

  tags = {
    ManagedBy = "IaC"
  }
}
