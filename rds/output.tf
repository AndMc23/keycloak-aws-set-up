output "database_hostname" {
  value = aws_db_instance.keycloakdb.address
}

output "database_port" {
  value = aws_db_instance.keycloakdb.port
}

output "database_username" {
  value = aws_db_instance.keycloakdb.username
}

output "database_name" {
  value = aws_db_instance.keycloakdb.db_name
}

output "database_password" {
  description = "The password for logging in to the database. Set to sensitive so it does not print to console"
  value       = random_password.db_password.result
  sensitive   = true
}