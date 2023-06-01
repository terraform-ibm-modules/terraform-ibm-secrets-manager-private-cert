resource "ibm_sm_private_certificate" "secrets_manager_private_certificate" {
  instance_id             = var.secrets_manager_guid
  region                  = var.secrets_manager_region
  name                    = var.cert_name
  certificate_template    = var.cert_template
  custom_metadata         = var.cert_custom_metadata
  version_custom_metadata = var.cert_version_custom_metadata
  description             = var.cert_description
  common_name             = var.cert_common_name
  labels                  = var.cert_labels
  secret_group_id         = var.cert_secrets_group_id
  alt_names               = var.cert_alt_names
  ip_sans                 = var.cert_ip_sans
  uri_sans                = var.cert_uri_sans
  ttl                     = var.cert_ttl
  csr                     = var.cert_csr
  other_sans              = var.cert_other_sans
  format                  = var.return_format
  private_key_format      = var.private_key_format
  exclude_cn_from_sans    = var.exclude_cn_from_sans

  rotation {
    auto_rotate = var.cert_rotation.auto_rotate
    interval    = var.cert_rotation.interval
    unit        = var.cert_rotation.unit
  }
}
