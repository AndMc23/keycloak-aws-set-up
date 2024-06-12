variable "alb_port" {
  description = "The port the ALB should listen on"
  default     = 80
}

variable "alb_target_port" {
  description = "The port the ALB should connect to backend services on on"
  default     = 8080
}

variable "alb_protocol" {
  description = "The protocol for the ALB"
  default     = "HTTP"
}

variable "alb_target_group_name" {
  description = "The name for the ALB target group"
  default     = "keycloak-target-group"
}

variable "alb_name" {
  description = "The name for the ALB"
  default     = "keycloak-alb"
}

variable "vpc_id" {}

variable "subnet_ids" {}

variable "security_groups" {}

variable "certificate_arn" {}

variable "enabled" {
  type        = bool
  description = "Determine whether health checks are enabled or not"
  default     = true
}

variable "healthy_threshold" {
  description = "Number of consecutive health check successes required before considering a target healthy"
  type        = number
  default     = 3
}

variable "interval" {
  description = "Approximate amount of time, in seconds, between health checks of an individual target"
  type        = number
  default     = 30
}

variable "path" {
  description = "Destination for the health check request. Required for HTTP/HTTPS ALB and HTTP NLB. Only applies to HTTP/HTTPS"
  type        = string
  default     = "/"
}

variable "port" {
  description = "The port the load balancer uses when performing health checks on targets."
  type        = number
  default     = 80
}

variable "protocol" {
  description = "Protocol the load balancer uses when performing health checks on targets"
  type        = string
  default     = "HTTP"
}

variable "timeout" {
  description = "Amount of time, in seconds, during which no response from a target means a failed health check"
  type        = number
  default     = 10
}

variable "unhealthy_threshold" {
  description = "Number of consecutive health check failures required before considering a target unhealthy"
  type        = number
  default     = 3
}