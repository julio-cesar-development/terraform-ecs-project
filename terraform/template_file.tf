data "template_file" "user-data" {
  template = file("${path.module}/templates/user-data.sh")

  vars = {
    ecs_cluster_name = "${var.ecs_cluster_name}-${var.env}"
  }
}
