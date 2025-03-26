variable "location" {
  type        = string
  default     = "francecentral"
  description = "Azure region for resources"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment tag (dev/stage/prod)"
}

variable "admin_username" {
  type        = string
  default     = "tumadmin"
  description = "Admin username for VMs"
  sensitive   = true
}