#
#   ECS TASK DEFINITION   
#
resource "aws_ecs_task_definition" "service" {
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
