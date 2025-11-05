variable "public_subnet_id"{}
variable "security_group" {}
variable "target_group" {
  
}

resource "aws_ecs_cluster" "main" {
  name = "ecs-8byte-cluster"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Effect = "Allow"
        Principal = {
            Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "webapp" {
 family = "8byte"
 requires_compatibilities = ["FARGATE"]
 network_mode = "awsvpc"
 cpu = "256"
 memory = "512"
 execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
 container_definitions = jsonencode([
    {
        name = "javawebapp"
        image = var.image_uri
        essential = true
        portMappings = [{
            containerPort = 8080
            hostPort = 8080
        }]
    }
 ])
}

resource "aws_ecs_service" "webapp_service" {
  name = "web-app"
  cluster = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.webapp.arn
  launch_type = "FARGATE"
  desired_count = 1

  network_configuration {
    subnets = [var.public_subnet_id]
    security_groups = [var.security_group]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group
    container_name = "javawebapp"
    container_port = 8080
  }
  depends_on = [ aws_iam_role_policy_attachment.ecs_task_execution_role_policy ]
}