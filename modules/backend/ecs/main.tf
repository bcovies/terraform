#
#   ECS TASK DEFINITION   
#
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family       = var.ecs_task_definition_family
  cpu          = var.ecs_task_definition_cpu
  memory       = var.ecs_task_definition_memory
  network_mode = var.ecs_task_definition_network_mode
  container_definitions = jsonencode([
    {
      "Name" : "${var.ecs_task_definition_container_definition_name}",
      "Image" : "${var.ecs_task_definition_container_definition_image}",
      "Cpu" : var.ecs_task_definition_container_definition_cpu,
      "Memory" : var.ecs_task_definition_container_definition_memory,
      "MemoryReservation" : var.ecs_task_definition_container_definition_memory_reservation,
      "PortMappings" : [
        {
          "ContainerPort" : var.ecs_task_definition_container_definition_container_port,
          "HostPort" : var.ecs_task_definition_container_definition_host_port
        }
      ],
      "EntryPoint" : [
        "/usr/sbin/apache2",
        "-D",
        "FOREGROUND"
      ],
      "Essential" : true,
      "Privileged" : true
    }
  ])
  tags = {
    ClusterName = "${var.cluster_name}"
    Environemnt = "${var.tag_environment}"
  }
}

#
# ECS SERVICE
#
resource "aws_ecs_service" "ecs_service" {
  name            = "mongodb"
  cluster         = aws_ecs_cluster.foo.id
  task_definition = aws_ecs_task_definition.mongo.arn
  desired_count   = 3
  iam_role        = aws_iam_role.foo.arn
  depends_on      = [aws_iam_role_policy.foo]

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.foo.arn
    container_name   = "mongo"
    container_port   = 8080
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}