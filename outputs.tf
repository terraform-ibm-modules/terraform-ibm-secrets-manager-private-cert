##############################################################################
# Outputs
##############################################################################

output "secret_id" {
  description = "Private certificates secrets manager secret ID"
  value       = restapi_object.secrets_manager_private_certificate.id
  sensitive   = false
}

output "secret_crn" {
  description = "Private certificates secrets manager secret CRN"
  value       = data.ibm_secrets_manager_secret.secrets_manager_secret.crn
}
