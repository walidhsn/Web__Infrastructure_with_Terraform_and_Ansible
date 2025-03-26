output "public_key" {
  value = jsondecode(azapi_resource_action.ssh_key_gen.output).publicKey
}