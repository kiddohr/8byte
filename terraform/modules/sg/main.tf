variable "vpc_id" {
  description = "VPC ID for security groups"
  type        = string
}

# --- ALB Security Group ---
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow ALB to send outbound traffic to anywhere (ECS will restrict inbound)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- ECS Security Group ---
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

  # Allow ECS to receive traffic only from ALB
  ingress {
    description              = "Allow traffic from ALB"
    from_port                = 8080
    to_port                  = 8080
    protocol                 = "tcp"
    security_groups          = [aws_security_group.alb_sg.id]
  }

  # Allow ECS to communicate outward (for updates, DB, etc.)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- RDS Security Group ---
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = var.vpc_id

  # Allow database connections from ECS
  ingress {
    description              = "Allow PostgreSQL traffic from ECS"
    from_port                = 5432
    to_port                  = 5432
    protocol                 = "tcp"
    security_groups          = [aws_security_group.ecs_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- Outputs ---
output "alb_sg" {
  description = "ALB security group ID"
  value       = aws_security_group.alb_sg.id
}

output "ecs_sg" {
  description = "ECS security group ID"
  value       = aws_security_group.ecs_sg.id
}

output "rds_sg" {
  description = "RDS security group ID"
  value       = aws_security_group.rds_sg.id
}
