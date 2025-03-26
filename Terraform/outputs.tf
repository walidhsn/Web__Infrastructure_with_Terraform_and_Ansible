output "key_vault_name" {
  value       = module.key_vault.vault_name
  description = "Key Vault name for SSH key retrieval"
}

output "vm_public_ips" {
  value       = module.web_vms.vm_public_ips
  description = "Public IPs of deployed VMs"
}

output "ssh_key_command" {
  value       = "az keyvault secret show --name vm-ssh-private-key --vault-name ${module.key_vault.vault_name} --query value -o tsv > ssh_key.pem && chmod 600 ssh_key.pem"
  description = "Command to retrieve SSH private key"
}