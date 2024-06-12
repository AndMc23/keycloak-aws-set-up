## ECS Service Role 
resource "aws_iam_role" "ecs_service" {
  name = "ecs_service_role"

  assume_role_policy = file("iam/resources/ecs_service_role.json")
}

resource "aws_iam_role_policy" "ecs_service" {
  name = "ecs_service_role_policy"
  role = aws_iam_role.ecs_service.name

  policy = file("iam/resources/ecs_service_role_policy.json")
}

## ECS Task Execution Role
resource "aws_iam_role" "task_exec_role" {
  name                = "ecs_service_role"
  managed_policy_arns = [""]
  assume_role_policy  = data.aws_iam_policy_document.task_exec_assume.json
}


## ECS Task Role
resource "aws_iam_role" "task_role" {
  name = "ecs_service_role"

  assume_role_policy = data.aws_iam_policy_document.tasks_assume.json
}

resource "aws_iam_role_policy" "task_policy" {
  name   = "ecs_service_role_policy"
  role   = aws_iam_role.ecs_service.name
  policy = data.aws_iam_policy_document.example.json
}

## EC2 Instance profile

resource "aws_iam_instance_profile" "app" {
  name = "ecs_app_instance_profile"
  role = aws_iam_role.app_instance.name
}

resource "aws_iam_role" "app_instance" {
  name = "ecs_app_instance_role"

  assume_role_policy = file("iam/resources/ecs_instance_role.json")
}

data "template_file" "instance_profile" {
  template = file("iam/templates/instance-profile-policy.tpl")

  vars = {
    app_log_group_arn = var.app_log_group_arn
    ecs_log_group_arn = var.ecs_log_group_arn
  }
}

resource "aws_iam_role_policy" "instance" {
  name   = "ecs_instance_role_policy"
  role   = aws_iam_role.app_instance.name
  policy = data.template_file.instance_profile.rendered
}
