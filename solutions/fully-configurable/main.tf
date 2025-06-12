locals {
  prefix = var.prefix != null ? trimspace(var.prefix) != "" ? "${var.prefix}-" : "" : ""
}

module "crn_parser" {
  source  = "terraform-ibm-modules/common-utilities/ibm//modules/crn-parser"
  version = "1.1.0"
  crn     = var.existing_secrets_manager_crn
}

locals {
  existing_secrets_manager_guid   = module.crn_parser.service_instance
  existing_secrets_manager_region = module.crn_parser.region
}

module "secrets_manager_private_cert" {
  source = "../.."

  secrets_manager_guid      = local.existing_secrets_manager_guid
  secrets_manager_region    = local.existing_secrets_manager_region
  
  cert_name                 = var.cert_name
  cert_template             = var.cert_template
  cert_common_name          = var.cert_common_name
  cert_secrets_group_id     = var.cert_secrets_group_id

  cert_alt_names            = var.cert_alt_names
  cert_ttl                  = var.cert_ttl
  return_format             = var.return_format
  private_key_format        = var.private_key_format
  exclude_cn_from_sans      = var.exclude_cn_from_sans
  service_endpoints         = var.service_endpoints
}
