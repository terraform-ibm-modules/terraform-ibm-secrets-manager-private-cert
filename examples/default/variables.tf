variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API token this account authenticates to"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "Region of the secrets manager instance"
  default     = "us-south"
}

variable "root_ca_name" {
  type        = string
  description = "Name of the Root CA to create for a private_cert secret engine"
  default     = "root-ca"
}

variable "intermediate_ca_name" {
  type        = string
  description = "Name of the Intermediate CA to create for a private_cert secret engine"
  default     = "intermediate-ca"
}

variable "certificate_template_name" {
  type        = string
  description = "Name of the Certificate Template to create for a private_cert secret engine"
  default     = "my-template"
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources"
  default     = []
}

variable "resource_group" {
  type        = string
  description = "An existing resource group name to use for this example, if unset a new resource group will be created"
  default     = null
}

variable "prefix" {
  type        = string
  description = "Prefix to be added to created resources"
  default     = "private-cert-test-alex"
}
