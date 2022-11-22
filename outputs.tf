##############################################################################
# Outputs
##############################################################################

output "secret_id" {
  description = "Private certificates secrets manager secret ID"
  value       = restapi_object.secrets_manager_private_certificate.id
  sensitive   = false
}
