module "app_bff_service" {
  source = "git::https://github.com/felipelima5/5dvpr-app-ecs.git?ref=v1.0.0"

  env              = "dev"
  region           = var.region
  application_name = "bff-api-service"
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
  arn_listener_alb             = "arn:aws:elasticloadbalancing:us-east-1:111109532426:listener/app/alb/2f7a3e0a42ec9aea/cf25ff56648c0402"
  alb_listener_host_rule       = "5dvpr.keephouseorder.net"
  priority_rule_listener       = 1

  # LoadBalancer TargetGroup
  target_protocol                  = "HTTP"
  target_protocol_version          = "HTTP1"
  target_deregistration_delay      = 10
  target_health_check_path         = "/healthcheck/ready"
  target_health_check_success_code = "200-499"

  security_group_alb = ["sg-0f76512cbdee0ee0f"] #Security Group do LoadBalancer Application que enviará as requests

  tags = {
    ManagedBy = "IaC"
  }
}
