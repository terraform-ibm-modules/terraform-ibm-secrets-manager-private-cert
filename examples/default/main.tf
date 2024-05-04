locals {
  sm_guid   = var.existing_sm_instance_guid == null ? module.secrets_manager.secrets_manager_guid : var.existing_sm_instance_guid
  sm_region = var.existing_sm_instance_region == null ? var.region : var.existing_sm_instance_region
}

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.5"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

module "secrets_manager" {
  source               = "terraform-ibm-modules/secrets-manager/ibm"
  version              = "1.12.4"
  resource_group_id    = module.resource_group.resource_group_id
  region               = var.region
  secrets_manager_name = "${var.prefix}-secrets-manager"
  sm_service_plan      = "trial"
  allowed_network      = "public-and-private"
  sm_tags              = var.resource_tags
}

# Best practice, use a secret group
resource "ibm_sm_secret_group" "secret_group" {
  name        = "${var.prefix}-certificates-secret-group"    #checkov:skip=CKV_SECRET_6: does not require high entropy string as is static value
  description = "secret group used for private certificates" #tfsec:ignore:general-secrets-no-plaintext-exposure
  region      = local.sm_region
  instance_id = local.sm_guid
}

module "private_secret_engine" {
  count                     = var.existing_sm_instance_guid == null ? 1 : 0
  source                    = "terraform-ibm-modules/secrets-manager-private-cert-engine/ibm"
  version                   = "1.3.1"
  secrets_manager_guid      = local.sm_guid
  region                    = local.sm_region
  root_ca_name              = var.root_ca_name
  intermediate_ca_name      = var.intermediate_ca_name
  certificate_template_name = var.certificate_template_name
  root_ca_common_name       = "terraform-modules.ibm.com"
  root_ca_max_ttl           = "87600h"
}

module "secrets_manager_private_certificate" {
  source     = "../.."
  depends_on = [module.private_secret_engine]

  cert_name              = "${var.prefix}-example-private-cert"
  cert_description       = "an example private cert"
  cert_secrets_group_id  = ibm_sm_secret_group.secret_group.secret_group_id
  cert_template          = var.certificate_template_name
  cert_common_name       = "terraform-modules.ibm.com"
  secrets_manager_guid   = local.sm_guid
  secrets_manager_region = local.sm_region
}
