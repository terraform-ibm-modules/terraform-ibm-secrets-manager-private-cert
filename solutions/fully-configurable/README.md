# Secrets Manager Private Certificate

This solution supports the following:
- Provisioning and configuring a secrets manager private certificate.

![secrets-manager-private-cert-deployable-architecture](../../reference-architecture/secrets_manager_private_cert.svg)

**NB:** This solution is not intended to be called by one or more other modules since it contains a provider configurations, meaning it is not compatible with the `for_each`, `count`, and `depends_on` arguments. For more information see [Providers Within Modules](https://developer.hashicorp.com/terraform/language/modules/develop/providers)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= v1.9.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | 1.79.2 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_crn_parser"></a> [crn\_parser](#module\_crn\_parser) | terraform-ibm-modules/common-utilities/ibm//modules/crn-parser | 1.1.0 |
| <a name="module_secrets_manager_private_cert"></a> [secrets\_manager\_private\_cert](#module\_secrets\_manager\_private\_cert) | ../.. | n/a |

### Resources

No resources.

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cert_alt_names"></a> [cert\_alt\_names](#input\_cert\_alt\_names) | Alternate names for the certificate to be created. | `list(string)` | `null` | no |
| <a name="input_cert_common_name"></a> [cert\_common\_name](#input\_cert\_common\_name) | Fully qualified domain name or host domain name for the certificate to be created. | `string` | `"cert-common-name"` | no |
| <a name="input_cert_csr"></a> [cert\_csr](#input\_cert\_csr) | Certificate Signing Request (CSR) to be used for certificate creation. If this parameter is not included, the CSR that is used to generate the certificate is created internally. [Learn More](https://cloud.ibm.com/docs/secrets-manager?topic=secrets-manager-secrets-manager-cli#secrets-manager-configurations-cli). | `string` | `null` | no |
| <a name="input_cert_custom_metadata"></a> [cert\_custom\_metadata](#input\_cert\_custom\_metadata) | Custom metadata for the certificate to be created. | `map(string)` | <pre>{<br/>  "collection_total": 1,<br/>  "collection_type": "application/vnd.ibm.secrets-manager.secret+json"<br/>}</pre> | no |
| <a name="input_cert_description"></a> [cert\_description](#input\_cert\_description) | Extended description of certificate to be created. To protect privacy, do not use personal data, such as name or location, as a description for certificate. | `string` | `null` | no |
| <a name="input_cert_ip_sans"></a> [cert\_ip\_sans](#input\_cert\_ip\_sans) | IP Subject Alternative Names (SANs) to define for the CA certificate, in a comma-delimited list. | `string` | `null` | no |
| <a name="input_cert_labels"></a> [cert\_labels](#input\_cert\_labels) | Labels for the certificate to be created. | `list(string)` | `[]` | no |
| <a name="input_cert_name"></a> [cert\_name](#input\_cert\_name) | Name of the certificate to be created in Secrets Manager. | `string` | `"cert-name"` | no |
| <a name="input_cert_other_sans"></a> [cert\_other\_sans](#input\_cert\_other\_sans) | The custom Object Identifier (OID) or UTF8-string Subject Alternative Names (SANs) to define for the CA certificate. The alternative names must match the values that are specified in the 'allowed\_other\_sans' field in the associated certificate template. | `list(string)` | `[]` | no |
| <a name="input_cert_rotation"></a> [cert\_rotation](#input\_cert\_rotation) | Rotation policy for the certificate to be created. | <pre>object({<br/>    auto_rotate = optional(bool)<br/>    interval    = optional(number)<br/>    unit        = optional(string)<br/>  })</pre> | <pre>{<br/>  "auto_rotate": true,<br/>  "interval": 12,<br/>  "unit": "month"<br/>}</pre> | no |
| <a name="input_cert_secrets_group_id"></a> [cert\_secrets\_group\_id](#input\_cert\_secrets\_group\_id) | ID of Secrets Manager secret group to store the certificate in. | `string` | `"default"` | no |
| <a name="input_cert_template"></a> [cert\_template](#input\_cert\_template) | Name of the certificate template to use. | `string` | n/a | yes |
| <a name="input_cert_ttl"></a> [cert\_ttl](#input\_cert\_ttl) | Time-to-live (TTL) to assign to a private certificate. | `string` | `"364d"` | no |
| <a name="input_cert_uri_sans"></a> [cert\_uri\_sans](#input\_cert\_uri\_sans) | URI Subject Alternative Names (SANs) to define for the CA certificate, in a comma-delimited list. | `string` | `null` | no |
| <a name="input_cert_version_custom_metadata"></a> [cert\_version\_custom\_metadata](#input\_cert\_version\_custom\_metadata) | Custom version metadata for the certificate to be created. | `map(string)` | `{}` | no |
| <a name="input_exclude_cn_from_sans"></a> [exclude\_cn\_from\_sans](#input\_exclude\_cn\_from\_sans) | Controls whether the common name is excluded from Subject Alternative Names (SANs). If set to true, the common name is not included in DNS or Email SANs if they apply. | `bool` | `false` | no |
| <a name="input_existing_secrets_manager_crn"></a> [existing\_secrets\_manager\_crn](#input\_existing\_secrets\_manager\_crn) | CRN of an existing secrets manager instance to create the secret engine in. | `string` | n/a | yes |
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | The IBM Cloud API key used to provision resources. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix to be added to all resources created by this solution. To skip using a prefix, set this value to null or an empty string. The prefix must begin with a lowercase letter and may contain only lowercase letters, digits, and hyphens '-'. It should not exceed 16 characters, must not end with a hyphen('-'), and can not contain consecutive hyphens ('--'). Example: prod-0205-cos. [Learn more](https://terraform-ibm-modules.github.io/documentation/#/prefix.md). | `string` | n/a | yes |
| <a name="input_private_key_format"></a> [private\_key\_format](#input\_private\_key\_format) | Format of the generated private key. | `string` | `"der"` | no |
| <a name="input_return_format"></a> [return\_format](#input\_return\_format) | Optional, Format of the returned data | `string` | `"pem"` | no |
| <a name="input_service_endpoints"></a> [service\_endpoints](#input\_service\_endpoints) | Service endpoint type to communicate with the provided secrets manager instance. Possible values are `public` or `private`. | `string` | `"private"` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Private certificates secrets manager secret resource ID |
| <a name="output_secret_crn"></a> [secret\_crn](#output\_secret\_crn) | Private certificates secrets manager secret CRN |
| <a name="output_secret_id"></a> [secret\_id](#output\_secret\_id) | Private certificates secrets manager secret unique ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
