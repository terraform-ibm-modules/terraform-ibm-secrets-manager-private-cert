terraform {
  required_version = ">= 1.0.0"
  required_providers {
    # Pin to the lowest provider version of the range defined in the main module's version.tf to ensure lowest version still works
    restapi = {
      source  = "Mastercard/restapi"
      version = "1.18.0"
    }
    # The ibm provider is not actually required by the module itself, just this example, so OK to use ">=" here instead of locking into a version
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.49.0"
    }
  }
}
