terraform {
  required_version = ">= 1.3.0"
  required_providers {
    # Pin to the lowest provider version of the range defined in the main module's version.tf to ensure lowest version still works
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">=1.79.0, <2.0.0"
    }
  }
}
