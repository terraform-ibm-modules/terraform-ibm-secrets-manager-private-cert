# Secrets Manager Private Cert module

[![Graduated (Supported)](https://img.shields.io/badge/Status-Graduated%20(Supported)-brightgreen)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-secrets-manager-private-cert?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-secrets-manager-private-cert/releases/latest)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

This module creates a private certificate in an existing Secrets Manager instance that has a configured [Private Certificate Engine](https://cloud.ibm.com/docs/secrets-manager?topic=secrets-manager-certificates&interface=ui).

The module handles the following resource:
- Secrets Manager private certificate

<!-- Below content is automatically populated via pre-commit hook -->
<!-- BEGIN OVERVIEW HOOK -->
## Overview
* [terraform-ibm-secrets-manager-private-cert](#terraform-ibm-secrets-manager-private-cert)
* [Examples](./examples)
    * <div style="display: inline-block;"><a href="./examples/default">Default example</a></div> <div style="display: inline-block; vertical-align: middle;"><a href="https://cloud.ibm.com/schematics/workspaces/create?workspace_name=smpc-default-example&repository=github.com/terraform-ibm-modules/terraform-ibm-secrets-manager-private-cert/tree/main/examples/default" target="_blank"><img src="https://cloud.ibm.com/media/docs/images/icons/Deploy_to_cloud.svg" alt="Deploy to IBM Cloud button"></a></div>
    * <div style="display: inline-block;"><a href="./examples/private">Private-Only Secret Manager example</a></div> <div style="display: inline-block; vertical-align: middle;"><a href="https://cloud.ibm.com/schematics/workspaces/create?workspace_name=smpc-private-example&repository=github.com/terraform-ibm-modules/terraform-ibm-secrets-manager-private-cert/tree/main/examples/private" target="_blank"><img src="https://cloud.ibm.com/media/docs/images/icons/Deploy_to_cloud.svg" alt="Deploy to IBM Cloud button"></a></div>
* [Contributing](#contributing)
<!-- END OVERVIEW HOOK -->

## terraform-ibm-secrets-manager-private-cert

### Usage

```hcl
module "secrets_manager_private_certificate" {
  source  = "terraform-ibm-modules/secrets-manager-private-cert/ibm"
  version = "latest" # Replace "latest" with a release version to lock into a specific release

  cert_name             = "example-private-cert"
  cert_description      = "an example private cert"
  cert_secrets_group_id = "the secret group ID to place the cert"
  cert_template         = "name of the cert template to use"
  cert_common_name      = "example.com"

  secrets_manager_guid   = module.secrets_manager.secrets_manager_guid
  secrets_manager_region = var.region
}
```

## Required IAM access policies

You need the following permissions to run this module.

- Account Management
  - **IAM Access Groups** service
      - `Editor` platform access
  - **IAM Identity** service
      - `Operator` platform access
  - **Resource Group** service
      - `Viewer` platform access
- IAM Services
  - **Secrets Manager** service
      - `Administrator` platform access
      - `Manager` service access

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >=1.79.0, <2.0.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [ibm_sm_private_certificate.secrets_manager_private_certificate](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/sm_private_certificate) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cert_alt_names"></a> [cert\_alt\_names](#input\_cert\_alt\_names) | Optional, Alternate names for the certificate to be created | `list(string)` | `null` | no |
| <a name="input_cert_common_name"></a> [cert\_common\_name](#input\_cert\_common\_name) | Fully qualified domain name or host domain name for the certificate to be created | `string` | n/a | yes |
| <a name="input_cert_csr"></a> [cert\_csr](#input\_cert\_csr) | Certificate signing request. If you don't include this parameter, the CSR that is used to generate the certificate is created internally | `string` | `null` | no |
| <a name="input_cert_custom_metadata"></a> [cert\_custom\_metadata](#input\_cert\_custom\_metadata) | Optional, Custom metadata for the certificate to be created | `map(string)` | <pre>{<br/>  "collection_total": 1,<br/>  "collection_type": "application/vnd.ibm.secrets-manager.secret+json"<br/>}</pre> | no |
| <a name="input_cert_description"></a> [cert\_description](#input\_cert\_description) | Optional, Extended description of certificate to be created. To protect privacy, do not use personal data, such as name or location, as a description for certificate | `string` | `null` | no |
| <a name="input_cert_ip_sans"></a> [cert\_ip\_sans](#input\_cert\_ip\_sans) | Optional, IP Subject Alternative Names (SANs) to define for the CA certificate, in a comma-delimited list | `string` | `null` | no |
| <a name="input_cert_labels"></a> [cert\_labels](#input\_cert\_labels) | Optional, Labels for the certificate to be created | `list(string)` | `[]` | no |
| <a name="input_cert_name"></a> [cert\_name](#input\_cert\_name) | Name of the certificate to be created in Secrets Manager | `string` | n/a | yes |
| <a name="input_cert_other_sans"></a> [cert\_other\_sans](#input\_cert\_other\_sans) | Optional, The custom Object Identifier (OID) or UTF8-string Subject Alternative Names (SANs) to define for the CA certificate. The alternative names must match the values that are specified in the 'allowed\_other\_sans' field in the associated certificate template | `list(string)` | `[]` | no |
| <a name="input_cert_rotation"></a> [cert\_rotation](#input\_cert\_rotation) | Optional, Rotation policy for the certificate to be created | <pre>object({<br/>    auto_rotate = optional(bool)<br/>    interval    = optional(number)<br/>    unit        = optional(string)<br/>  })</pre> | <pre>{<br/>  "auto_rotate": true,<br/>  "interval": 12,<br/>  "unit": "month"<br/>}</pre> | no |
| <a name="input_cert_secrets_group_id"></a> [cert\_secrets\_group\_id](#input\_cert\_secrets\_group\_id) | Optional, Id of Secrets Manager secret group to store the certificate in | `string` | `"default"` | no |
| <a name="input_cert_template"></a> [cert\_template](#input\_cert\_template) | Name of the certificate template to use | `string` | n/a | yes |
| <a name="input_cert_ttl"></a> [cert\_ttl](#input\_cert\_ttl) | Optional, Time-to-live (TTL) to assign to a private certificate | `string` | `"364d"` | no |
| <a name="input_cert_uri_sans"></a> [cert\_uri\_sans](#input\_cert\_uri\_sans) | Optional, URI Subject Alternative Names (SANs) to define for the CA certificate, in a comma-delimited list | `string` | `null` | no |
| <a name="input_cert_version_custom_metadata"></a> [cert\_version\_custom\_metadata](#input\_cert\_version\_custom\_metadata) | Optional, Custom version metadata for the certificate to be created | `map(string)` | `{}` | no |
| <a name="input_endpoint_type"></a> [endpoint\_type](#input\_endpoint\_type) | The endpoint type to communicate with the provided secrets manager instance. Possible values are `public` or `private` | `string` | `"public"` | no |
| <a name="input_exclude_cn_from_sans"></a> [exclude\_cn\_from\_sans](#input\_exclude\_cn\_from\_sans) | Optional, Controls whether the common name is excluded from Subject Alternative Names (SANs). If set to true, the common name is not included in DNS or Email SANs if they apply | `bool` | `false` | no |
| <a name="input_private_key_format"></a> [private\_key\_format](#input\_private\_key\_format) | Optional, Format of the generated private key | `string` | `"der"` | no |
| <a name="input_return_format"></a> [return\_format](#input\_return\_format) | Optional, Format of the returned data | `string` | `"pem"` | no |
| <a name="input_secrets_manager_guid"></a> [secrets\_manager\_guid](#input\_secrets\_manager\_guid) | Secrets Manager GUID | `string` | n/a | yes |
| <a name="input_secrets_manager_region"></a> [secrets\_manager\_region](#input\_secrets\_manager\_region) | Region the Secrets Manager instance is in | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Private certificates secrets manager secret resource ID |
| <a name="output_secret_crn"></a> [secret\_crn](#output\_secret\_crn) | Private certificates secrets manager secret CRN |
| <a name="output_secret_id"></a> [secret\_id](#output\_secret\_id) | Private certificates secrets manager secret unique ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
