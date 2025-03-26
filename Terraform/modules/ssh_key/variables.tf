variable "resource_group_id" {
  type        = string
  description = "Resource group ID"
}

variable "key_vault_id" {
  type        = string
  description = "Key Vault ID for storing private key"
}

variable "location" {
  type        = string
  description = "Azure region"
}
