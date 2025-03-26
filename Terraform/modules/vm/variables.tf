variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "vm_count" {
  type        = number
  default     = 2
  description = "Number of VMs to deploy"
}

variable "vm_name_prefix" {
  type        = string
  default     = "web"
  description = "Prefix for VM names"
}

variable "main_subnet_id" {
  type        = string
  description = "Main subnet ID"
}

variable "lb_subnet_id" {
  type        = string
  description = "Load balancer subnet ID"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key"
}

variable "admin_username" {
  type        = string
  description = "Admin username"
  sensitive   = true
}

variable "backend_pool_id" {
  type        = string
  description = "Load balancer backend pool ID"
}

variable "vm_size" {
  type        = string
  default     = "Standard_B2s"
  description = "VM size"
}
