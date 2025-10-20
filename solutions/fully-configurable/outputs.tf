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
