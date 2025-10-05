locals {
  prefix = var.prefix != null && trimspace(var.prefix) != "" ? "${trimspace(var.prefix)}-" : ""
}

module "crn_parser" {
  source  = "terraform-ibm-modules/common-utilities/ibm//modules/crn-parser"
  version = "1.2.0"
  crn     = var.existing_secrets_manager_crn
}

locals {
  existing_secrets_manager_guid   = module.crn_parser.service_instance
  existing_secrets_manager_region = module.crn_parser.region
  # Extract only name => id map for easier lookup
  secret_group_name_id_map = {
    for group in data.ibm_sm_secret_groups.existing_secret_groups.secret_groups :
    group.name => group.id
  }

  # Check if the cert_secret_group_name exists in the map
  is_existing_group = contains(keys(local.secret_group_name_id_map), var.cert_secret_group_name)

  # Get the id if the group exists, otherwise null
  existing_group_id = local.is_existing_group ? local.secret_group_name_id_map[var.cert_secret_group_name] : null
}


data "ibm_sm_secret_groups" "existing_secret_groups" {
  instance_id   = local.existing_secrets_manager_guid
  region        = local.existing_secrets_manager_region
  endpoint_type = var.service_endpoints
}

module "secret_group" {
  count                    = var.create_secret_group ? 1 : 0
  source                   = "terraform-ibm-modules/secrets-manager-secret-group/ibm"
  version                  = "1.3.15"
  region                   = local.existing_secrets_manager_region
  secrets_manager_guid     = local.existing_secrets_manager_guid
  secret_group_name        = var.cert_secret_group_name
  secret_group_description = "Secret group for storing private certificate"
  endpoint_type            = var.service_endpoints
}


module "secrets_manager_private_cert" {
  source = "../.."

  secrets_manager_guid   = local.existing_secrets_manager_guid
  secrets_manager_region = local.existing_secrets_manager_region

  cert_name                    = "${local.prefix}${var.cert_name}"
  cert_template                = var.cert_template
  cert_common_name             = var.cert_common_name
  cert_secrets_group_id        = local.is_existing_group ? local.existing_group_id : module.secret_group[0].secret_group_id
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
  service_endpoints            = var.service_endpoints
}
