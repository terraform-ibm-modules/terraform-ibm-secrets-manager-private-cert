output "id" {
  description = "Private certificates secrets manager secret resource ID"
  value       = module.secrets_manager_private_cert.id
}

output "secret_id" {
  description = "Private certificates secrets manager secret unique ID"
  value       = module.secrets_manager_private_cert.secret_id
}

output "secret_crn" {
  description = "Private certificates secrets manager secret CRN"
  value       = module.secrets_manager_private_cert.secret_crn
}

output "secrets_manager_crn" {
  description = "The CRN of the Secrets Manager instance"
  value       = var.existing_secrets_manager_crn
}


output "next_steps_text" {
  value       = "Your Private Certificates are ready."
  description = "Next steps text"
}

output "next_step_primary_label" {
  value       = "View Private Certificates"
  description = "Primary label"
}

output "next_step_primary_url" {
  value       = "https://cloud.ibm.com/services/secrets-manager/${var.existing_secrets_manager_crn}?paneId=privateCertificates#/privateCertificates"
  description = "Primary URL"
}


