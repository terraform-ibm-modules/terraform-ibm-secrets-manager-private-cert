##############################################################################
# Outputs
##############################################################################

output "secret_id" {
  description = "Private certificates secrets manager secret ID"
  value       = ibm_sm_private_certificate.secrets_manager_private_certificate.id
}

output "secret_crn" {
  description = "Private certificates secrets manager secret CRN"
  value       = ibm_sm_private_certificate.secrets_manager_private_certificate.crn
}
