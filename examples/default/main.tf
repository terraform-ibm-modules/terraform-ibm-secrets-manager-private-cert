locals {
  sm_guid   = var.existing_sm_instance_guid == null ? module.secrets_manager[0].secrets_manager_guid : var.existing_sm_instance_guid
  sm_region = var.existing_sm_instance_region == null ? var.region : var.existing_sm_instance_region
}

module "resource_group" {
  source = "git::https://github.com/terraform-ibm-modules/terraform-ibm-resource-group.git?ref=v1.0.5"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

module "secrets_manager" {
  count = var.existing_sm_instance_guid == null ? 1 : 0
  providers = {
    restapi.nocontent = restapi.nocontent
  }
  source               = "git::https://github.ibm.com/GoldenEye/secrets-manager-module.git?ref=2.6.12"
  resource_group_id    = module.resource_group.resource_group_id
  region               = local.sm_region
  secrets_manager_name = "${var.prefix}-secrets-manager" #tfsec:ignore:general-secrets-no-plaintext-exposure
  sm_service_plan      = "trial"
  sm_tags              = var.resource_tags
}
# Best practise, use the secrets manager secret group module to create a secret group
module "secrets_manager_secret_group" {
  source                   = "git::https://github.ibm.com/GoldenEye/secrets-manager-secret-group-module.git?ref=1.5.2"
  region                   = local.sm_region
  secrets_manager_guid     = local.sm_guid
  secret_group_name        = "${var.prefix}-certificates-secret-group"    #checkov:skip=CKV_SECRET_6: does not require high entropy string as is static value
  secret_group_description = "secret group used for private certificates" #tfsec:ignore:general-secrets-no-plaintext-exposure
}

module "private_secret_engine" {
  count                     = var.existing_sm_instance_guid == null ? 1 : 0
  source                    = "git::https://github.ibm.com/GoldenEye/secrets-manager-private-cert-engine-module.git?ref=1.1.2"
  secrets_manager_guid      = local.sm_guid
  region                    = local.sm_region
  root_ca_name              = var.root_ca_name
  intermediate_ca_name      = var.intermediate_ca_name
  certificate_template_name = var.certificate_template_name
}

module "secrets_manager_private_certificate" {
  source     = "../.."
  depends_on = [module.private_secret_engine]

  cert_name             = "${var.prefix}-example-private-cert"
  cert_description      = "an example private cert"
  cert_secrets_group_id = module.secrets_manager_secret_group.secret_group_id
  cert_template         = var.certificate_template_name
  cert_common_name      = "goldeneye.appdomain.cloud"

  secrets_manager_guid   = local.sm_guid
  secrets_manager_region = local.sm_region
}
