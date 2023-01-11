locals {
  regional_endpoint        = var.service_endpoints == "private" ? "private.${var.secrets_manager_region}" : var.secrets_manager_region
  secrets_manager_endpoint = "//${var.secrets_manager_guid}.${local.regional_endpoint}.secrets-manager.appdomain.cloud"
}

resource "restapi_object" "secrets_manager_private_certificate" {
  path = "${local.secrets_manager_endpoint}/api/v1/secrets/private_cert"
  data = jsonencode({
    metadata = {
      collection_type  = "application/vnd.ibm.secrets-manager.secret+json",
      collection_total = 1
    },
    resources = [{
      name                 = var.cert_name,
      description          = var.cert_description,
      secret_group_id      = var.cert_secrets_group_id,
      certificate_template = var.cert_template,
      common_name          = var.cert_common_name,
      alt_names            = var.cert_alt_names,
      ip_sans              = var.cert_ip_sans,
      uri_sans             = var.cert_uri_sans,
      ttl                  = var.cert_ttl,
      rotation = {
        auto_rotate = true,
        interval    = 1,
        unit        = "month"
      }
    }]
  })
  create_method = "POST"
  id_attribute  = "resources/0/id"
  force_new     = ["name", "description", "secret_group_id", "certificate_template", "common_name", "alt_names", "ip_sans", "uri_sans", "ttl", "rotation", "resources"]
}

data "ibm_secrets_manager_secret" "secrets_manager_secret" {
  instance_id = var.secrets_manager_guid
  secret_type = "private_cert"
  secret_id   = restapi_object.secrets_manager_private_certificate.id
}
