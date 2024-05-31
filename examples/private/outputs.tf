##############################################################################
# Outputs
##############################################################################

output "secret_id" {
  description = "Private certificates secrets manager secret ID"
  value       = module.secrets_manager_private_certificate.secret_id
}

output "secret_crn" {
  description = "Private certificates secrets manager secret CRN"
  value       = module.secrets_manager_private_certificate.secret_crn
}
