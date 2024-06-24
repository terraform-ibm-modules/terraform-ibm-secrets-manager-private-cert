##############################################################################
# Outputs
##############################################################################

output "id" {
  description = "Private certificates secrets manager secret resource ID"
  value       = ibm_sm_private_certificate.secrets_manager_private_certificate.id
}

output "secret_id" {
  description = "Private certificates secrets manager secret unique ID"
  value       = ibm_sm_private_certificate.secrets_manager_private_certificate.secret_id
}

output "secret_crn" {
  description = "Private certificates secrets manager secret CRN"
  value       = ibm_sm_private_certificate.secrets_manager_private_certificate.crn
}
