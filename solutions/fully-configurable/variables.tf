variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API key used to provision resources."
  sensitive   = true
}

variable "existing_secrets_manager_crn" {
  type        = string
  description = "CRN of an existing secrets manager instance to create the secret engine in."
}

variable "prefix" {
  type        = string
  nullable    = true
  description = "The prefix to be added to all resources created by this solution. To skip using a prefix, set this value to null or an empty string. The prefix must begin with a lowercase letter and may contain only lowercase letters, digits, and hyphens '-'. It should not exceed 16 characters, must not end with a hyphen('-'), and can not contain consecutive hyphens ('--'). Example: prod-0205-cos. [Learn more](https://terraform-ibm-modules.github.io/documentation/#/prefix.md)."

  validation {
    # - null and empty string is allowed
    # - Must not contain consecutive hyphens (--): length(regexall("--", var.prefix)) == 0
    # - Starts with a lowercase letter: [a-z]
    # - Contains only lowercase letters (a–z), digits (0–9), and hyphens (-)
    # - Must not end with a hyphen (-): [a-z0-9]
    condition = (var.prefix == null || var.prefix == "" ? true :
      alltrue([
        can(regex("^[a-z][-a-z0-9]*[a-z0-9]$", var.prefix)),
        length(regexall("--", var.prefix)) == 0
      ])
    )
    error_message = "Prefix must begin with a lowercase letter and may contain only lowercase letters, digits, and hyphens '-'. It must not end with a hyphen('-'), and cannot contain consecutive hyphens ('--')."
  }

  validation {
    # must not exceed 16 characters in length
    condition     = length(var.prefix) <= 16
    error_message = "Prefix must not exceed 16 characters."
  }
}

# Certificate

variable "cert_name" {
  type        = string
  description = "Name of the certificate to be created in Secrets Manager."

  validation {
    condition     = length(var.cert_name) > 1 && length(var.cert_name) <= 256
    error_message = "length of cert_name must be > 1 and <= 256"
  }

  validation {
    condition     = can(regex("^\\w(([\\w-.]+)?\\w)?$", var.cert_name))
    error_message = "cert_name must match regular expression /^\\w(([\\w-.]+)?\\w)?$/"
  }
}

variable "cert_description" {
  type        = string
  description = "Extended description of certificate to be created. To protect privacy, do not use personal data, such as name or location, as a description for certificate."
  default     = null

  validation {
    condition     = var.cert_description == null ? true : length(var.cert_description) <= 1024
    error_message = "length of cert_description must be <= 1024"
  }

  validation {
    condition     = var.cert_description == null ? true : can(regex("(.*?)", var.cert_description))
    error_message = "cert_description must match regular expression /(.*?)/"
  }
}

variable "cert_secrets_group_id" {
  type        = string
  description = "Id of Secrets Manager secret group to store the certificate in."
  default     = "default"

  validation {
    condition     = var.cert_secrets_group_id == null ? true : length(var.cert_secrets_group_id) >= 7 && length(var.cert_secrets_group_id) <= 36
    error_message = "length of cert_secrets_group_id must be >= 7 and <= 36"
  }

  validation {
    condition     = can(regex("^([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}|default)$", var.cert_secrets_group_id))
    error_message = "cert_secrets_group_id match regular expression /^([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}|default)$/"
  }
}

variable "cert_template" {
  type        = string
  description = "Name of the certificate template to use."

  validation {
    condition     = length(var.cert_template) >= 2 && length(var.cert_template) <= 128
    error_message = "length of cert_template must be >= 2 and <= 128"
  }

  validation {
    condition     = can(regex("^[A-Za-z0-9][A-Za-z0-9]*(?:_?-?\\.?[A-Za-z0-9]+)*$", var.cert_template))
    error_message = "cert_template must match regular expression /^[A-Za-z0-9][A-Za-z0-9]*(?:_?-?\\.?[A-Za-z0-9]+)*$/"
  }
}

variable "cert_csr" {
  type        = string
  description = "Certificate signing request. If you don't include this parameter, the CSR that is used to generate the certificate is created internally."
  default     = null

  validation {
    condition     = var.cert_csr == null ? true : can(regex("^(-{5}BEGIN.+?-{5}[\\s\\S]+-{5}END.+?-{5})$", var.cert_csr))
    error_message = "cert_csr must match regular expression /^(-{5}BEGIN.+?-{5}[\\s\\S]+-{5}END.+?-{5})$/"
  }
}

variable "cert_common_name" {
  type        = string
  description = "Fully qualified domain name or host domain name for the certificate to be created."

  validation {
    condition     = length(var.cert_common_name) >= 4 && length(var.cert_common_name) <= 128
    error_message = "length of cert_common_name must be >= 4 and <= 128"
  }

  validation {
    condition     = can(regex("(.*?)", var.cert_common_name))
    error_message = "cert_common_name must match regular expression /(.*?)/"
  }
}

variable "cert_alt_names" {
  type        = list(string)
  description = "Alternate names for the certificate to be created."
  default     = null

  validation {
    condition     = var.cert_alt_names == null ? true : length(var.cert_alt_names) < 100
    error_message = "length of cert_alt_names must be < 100"
  }

  validation {
    condition = var.cert_alt_names == null ? true : alltrue([
      for cert_alt_name in var.cert_alt_names : can(regex("^(.*?)$", cert_alt_name))
    ])
    error_message = "list items must match regular expression /^(.*?)$/"
  }
}

variable "cert_custom_metadata" {
  type        = map(string)
  description = "Custom metadata for the certificate to be created."
  default = {
    collection_type  = "application/vnd.ibm.secrets-manager.secret+json",
    collection_total = 1
  }
}

variable "cert_version_custom_metadata" {
  type        = map(string)
  description = "Custom version metadata for the certificate to be created."
  default     = {}
}

variable "cert_labels" {
  type        = list(string)
  description = "Labels for the certificate to be created."
  default     = []

  validation {
    condition     = length(var.cert_labels) <= 30
    error_message = "length of cert_labels must be <= 30"
  }

  validation {
    condition = alltrue([
      for cert_label in var.cert_labels : can(regex("(.*?)", cert_label)) && length(cert_label) >= 2 && length(cert_label) <= 30
    ])
    error_message = "list items must match regular expression /(.*?)/, length of list items must be >= 2 and <= 30"
  }
}

variable "cert_rotation" {
  type = object({
    auto_rotate = optional(bool)
    interval    = optional(number)
    unit        = optional(string)
  })
  description = "Rotation policy for the certificate to be created."
  default = {
    auto_rotate = true
    interval    = 12
    unit        = "month"
  }

  validation {
    condition     = var.cert_rotation.interval > 0
    error_message = "secret rotation time interval must be > 0"
  }

  validation {
    condition     = contains(["day", "month"], var.cert_rotation.unit)
    error_message = "The specified rotation unit is not valid. Allowed values are: day, month."
  }
}

variable "cert_ip_sans" {
  type        = string
  description = "IP Subject Alternative Names (SANs) to define for the CA certificate, in a comma-delimited list."
  default     = null

  validation {
    condition     = var.cert_ip_sans == null ? true : length(var.cert_ip_sans) <= 2048
    error_message = "length of cert_ip_sans must <= 2048"
  }
}

variable "cert_uri_sans" {
  type        = string
  description = "URI Subject Alternative Names (SANs) to define for the CA certificate, in a comma-delimited list."
  default     = null

  validation {
    condition     = var.cert_uri_sans == null ? true : length(var.cert_uri_sans) >= 2 && length(var.cert_uri_sans) <= 2048
    error_message = "length of cert_uri_sans must be >= 2 and <= 2048"
  }
}

variable "cert_ttl" {
  type        = string
  description = "Time-to-live (TTL) to assign to a private certificate."
  default     = "364d"

  validation {
    condition     = var.cert_ttl == null ? true : can(regex("^[0-9]+[s,m,h,d]{0,1}$", var.cert_ttl))
    error_message = "cert_ttl must match regular expression /^[0-9]+[s,m,h,d]{0,1}$/"
  }
}

variable "cert_other_sans" {
  type        = list(string)
  description = "The custom Object Identifier (OID) or UTF8-string Subject Alternative Names (SANs) to define for the CA certificate. The alternative names must match the values that are specified in the 'allowed_other_sans' field in the associated certificate template."
  default     = []
}

variable "return_format" {
  type        = string
  description = "Optional, Format of the returned data"
  default     = "pem"
  validation {
    condition     = contains(["pem", "pem_bundle"], var.return_format)
    error_message = "The specified return_format is not valid. Allowed values are: pem, pem_bundle."
  }
}

variable "private_key_format" {
  type        = string
  description = "Format of the generated private key."
  default     = "der"
  validation {
    condition     = contains(["der", "pkcs8"], var.private_key_format)
    error_message = "The specified return_format is not valid. Allowed values are: der, pkcs8."
  }
}

variable "exclude_cn_from_sans" {
  type        = bool
  description = "Controls whether the common name is excluded from Subject Alternative Names (SANs). If set to true, the common name is not included in DNS or Email SANs if they apply."
  default     = false
}

variable "service_endpoints" {
  type        = string
  description = "Service endpoint type to communicate with the provided secrets manager instance. Possible values are `public` or `private`."
  default     = "private"
  validation {
    condition     = contains(["public", "private"], var.service_endpoints)
    error_message = "The specified service_endpoints is not a valid selection!"
  }
}
