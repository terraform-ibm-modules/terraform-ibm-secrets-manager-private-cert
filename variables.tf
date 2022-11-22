##############################################################################
# Input Variables
##############################################################################

# Common

##############################################################################

# Certificate

variable "cert_name" {
  type        = string
  description = "The name of the certificate in Secrets Manager"
}

variable "cert_description" {
  type        = string
  description = "The certificates description"
  default     = ""
}

variable "cert_secrets_group_id" {
  type        = string
  description = "The id of Secrets Manager secret group to store the certificate in"
  default     = ""
}

variable "cert_template" {
  type        = string
  description = "The name of the certificate template to use"
  default     = ""
}

variable "cert_common_name" {
  type        = string
  description = "The certificates common name"
}

variable "cert_alt_names" {
  type        = string
  description = "The certificates alternate names (comma separated)"
  default     = ""
}

variable "cert_ip_sans" {
  type        = string
  description = "The certificates IP sans"
  default     = ""
}

variable "cert_uri_sans" {
  type        = string
  description = "The certificates URI sans"
  default     = ""
}

variable "cert_ttl" {
  type        = string
  description = "The certificates ttl"
  default     = ""
}

##############################################################################

# Secrets Manager

variable "secrets_manager_guid" {
  type        = string
  description = "The Secrets Manager GUID"
}

variable "secrets_manager_region" {
  type        = string
  description = "The region the Secrets Manager instance is in"
}

variable "service_endpoints" {
  type        = string
  description = "The service endpoint type to communicate with the provided secrets manager instance. Possible values are `public` or `private`"
  default     = "public"
  validation {
    condition     = contains(["public", "private"], var.service_endpoints)
    error_message = "The specified service_endpoints is not a valid selection!"
  }
}
