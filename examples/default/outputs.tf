##############################################################################
# Outputs
##############################################################################

output "secret_id" {
  description = "Private certificates secrets manager secret ID"
  value       = module.secrets_manager_private_certificate.secret_id
  sensitive   = false
}
