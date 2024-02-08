# ecs.tf

resource "aws_ecs_cluster" "main" {
  name = "${var.service_name}-cluster-${var.environment}"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.service_name}-task-${var.environment}"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = jsonencode([
    {
      name : var.service_name,
      image : "${aws_ecr_repository.ecr.repository_url}:${var.image_tag}",
      cpu : var.fargate_cpu,
      memory : var.fargate_memory,
      networkMode : "awsvpc",
      logConfiguration : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : aws_cloudwatch_log_group.cb_log_group.name,
          "awslogs-region" : var.aws_region,
          "awslogs-stream-prefix" : "ecs"
        }
      },
      portMappings : [
        {
          "containerPort" : var.app_port,
          "hostPort" : var.app_port
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "main" {
  name            = "${var.service_name}_service_${var.environment}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [
      aws_security_group.ecs_tasks.id,
      aws_security_group.lb.id
    ]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = var.service_name
    container_port   = var.app_port
  }

  depends_on = [
    aws_alb_listener.front_end, aws_alb_listener.front_end_https, aws_iam_role_policy_attachment.ecs_task_execution_role
  ]
}
