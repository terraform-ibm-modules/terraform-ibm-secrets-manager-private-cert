locals {
  prefix                          = var.prefix != null && trimspace(var.prefix) != "" ? "${trimspace(var.prefix)}-" : ""
  cert_secret_group_name          = "${local.prefix}secrets-group"
  existing_secrets_manager_guid   = module.crn_parser.service_instance
  existing_secrets_manager_region = module.crn_parser.region
}

module "crn_parser" {
  source  = "terraform-ibm-modules/common-utilities/ibm//modules/crn-parser"
  version = "1.4.1"
  crn     = var.existing_secrets_manager_crn
}

module "secret_group" {
  count                    = var.cert_secrets_group_id == null ? 1 : 0
  source                   = "terraform-ibm-modules/secrets-manager-secret-group/ibm"
  version                  = "1.3.39"
  region                   = local.existing_secrets_manager_region
  secrets_manager_guid     = local.existing_secrets_manager_guid
  secret_group_name        = local.cert_secret_group_name
  secret_group_description = "Secret group for storing private certificate"
  endpoint_type            = var.endpoint_type
}

module "secrets_manager_private_cert" {
  source = "../.."

  secrets_manager_guid   = local.existing_secrets_manager_guid
  secrets_manager_region = local.existing_secrets_manager_region

  cert_name                    = "${local.prefix}${var.cert_name}"
  cert_template                = var.cert_template
  cert_common_name             = var.cert_common_name
  cert_secrets_group_id        = var.cert_secrets_group_id != null ? var.cert_secrets_group_id : module.secret_group[0].secret_group_id
  cert_description             = var.cert_description
  cert_csr                     = var.cert_csr
  cert_custom_metadata         = var.cert_custom_metadata
  cert_labels                  = var.cert_labels
  cert_rotation                = var.cert_rotation
  cert_ip_sans                 = var.cert_ip_sans
  cert_uri_sans                = var.cert_uri_sans
  cert_other_sans              = var.cert_other_sans
  cert_version_custom_metadata = var.cert_version_custom_metadata
  cert_alt_names               = var.cert_alt_names
  cert_ttl                     = var.cert_ttl
  return_format                = var.return_format
  private_key_format           = var.private_key_format
  exclude_cn_from_sans         = var.exclude_cn_from_sans
  endpoint_type                = var.endpoint_type
}
