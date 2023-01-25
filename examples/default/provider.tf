# Data source to retrieve token details
data "ibm_iam_auth_token" "token_data" {
}

# RestAPI provider using standard / default configuration
provider "restapi" {
  uri                  = "https:"
  write_returns_object = true
  debug                = false # set to true to show detailed logs, but use carefully as it might print sensitive values.
  headers = {
    Accept        = "application/json"
    Authorization = data.ibm_iam_auth_token.token_data.iam_access_token
    Content-Type  = "application/json"
  }
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.existing_sm_instance_region == null ? var.region : var.existing_sm_instance_region
}
