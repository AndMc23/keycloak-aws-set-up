output "alb_public_dns" {
  value = module.alb.alb_dns_name
}

output "public_dns_name" {
  value = var.public_dns_name
}

output "database_password" {
  description = "The password for logging in to the database. Set to sensitive so it does not print to console"
  value       = module.rds.database_password
  sensitive   = true
}


output "database_port" {
  value = module.rds.database_port
}

output "database_username" {
  value = module.rds.database_username
}

output "database_name" {
  value = module.rds.database_name
}

output "ecs_iam_task_exec_role_arn" {
  value = module.iam.ecs_iam_task_exec_role_arn
}

output "ecs_iam_task_role_arn" {
  value = module.iam.ecs_iam_task_role_arn
}