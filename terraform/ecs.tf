
resource "aws_ecs_cluster" "ecsdev" {
  name = "ecsdev"
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = "100"
  }
}


resource "aws_ecs_task_definition" "jenkins" {
  family = "jenkins"
  requires_compatibilities = [
    "FARGATE",
  ]
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  network_mode       = "awsvpc"
  cpu                = 1024
  memory             = 2048
  container_definitions = jsonencode([
    {
      name      = "jenkins"
      image     = var.image_jenkins_ecs_master
      essential = true

      mountPoints = [
          {
              containerPath = "/var/jenkins_home"
              sourceVolume = "efs-jenkins"
          }
      ]

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    }
  ])


  volume {
    name      = "efs-jenkins"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.jenkins.id
      root_directory = "/jenkins-master"
    }
  }

  
}


resource "aws_ecs_service" "jenkins" {
  name            = "jenkins"
  cluster         = aws_ecs_cluster.ecsdev.id
  task_definition = aws_ecs_task_definition.jenkins.arn
  desired_count   = 1
  depends_on      = [aws_iam_role.ecs_task_execution_role]
  platform_version = "1.4.0"
  launch_type     = "FARGATE"

  network_configuration {
    security_groups    = [aws_security_group.dev_svc.id, aws_security_group.jenkins_dev.id]
    subnets            = [aws_subnet.ecs_subnet_2.id, aws_subnet.ecs_subnet_3.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.albdev.arn
    container_name   = "jenkins"
    container_port   = 8080
  }

}


