terraform {
  required_version = ">= 1.0.0"
  required_providers {
    # Use "greater than or equal to" range in modules
    restapi = {
      source  = "Mastercard/restapi"
      version = ">= 1.17.0"
    }
  }
}
