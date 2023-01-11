# Secrets Manager Private Cert module
[![Stable (Adopted)](https://img.shields.io/badge/Status-Stable%20(Adopted)-yellowgreen?style=plastic)](https://github.ibm.com/GoldenEye/documentation/blob/master/status.md)
[![Build status](https://travis.ibm.com/GoldenEye/module-template.svg?token=3Ry6sEDNvWajQPuZHgTZ&branch=master)](https://travis.ibm.com/GoldenEye/module-template)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![latest release](https://shields-server.m03l6u0cqkx.eu-de.codeengine.appdomain.cloud/github/v/release/GoldenEye/module-template?logo=GitHub)](https://github.ibm.com/GoldenEye/module-template/releases/latest)

This module creates a private certificate in an existing Secrets Manager instance that has a configured [Private Certificate Engine](https://cloud.ibm.com/docs/secrets-manager?topic=secrets-manager-certificates&interface=ui).

The module handles the following resource:
- Secrets Manager private certificate

The module uses the Terraform provider for [generic REST APIs](https://github.com/Mastercard/terraform-provider-restapi) because of limitations with the IBM Cloud provider. The limitations are tracked in GitHub at https://github.com/IBM-Cloud/terraform-provider-ibm/issues/2054.

## Usage

Make sure that you set the following environment variable to hide sensitive data before you run Terraform operations (for example, `plan`, `apply`, `destroy`):

```
API_DATA_IS_SENSITIVE=true
```
For more information, see the [provider documentation](https://github.com/Mastercard/terraform-provider-restapi#usage) for generic REST APIs.

```hcl
# Replace "master" with a GIT release version to lock into a specific release
module "secrets_manager_private_certificate" {
  source     = "git::ssh://github.ibm.com/GoldenEye/secrets-manager-private-cert-module?ref=master"

  cert_name             = "example-private-cert"
  cert_description      = "an example private cert"
  cert_secrets_group_id = "the secret group ID to place the cert"
  cert_template         = "name of the cert template to use"
  cert_common_name      = "goldeneye.appdomain.cloud"

  secrets_manager_guid   = module.secrets_manager.secrets_manager_guid
  secrets_manager_region = var.region
}
```

 In addition to the regular Rest API provider block, this module requires a second Rest API provider configuration block in the Terraform file that calls the API. The block needs an `alias` that is set to `nocontent` as shown in the following example:

```
provider "restapi" {
  alias                 = "nocontent"
  uri                   = "https:"
  write_returns_object  = false
  create_returns_object = false
  debug                 = false # set to true to show detailed logs, but use carefully as it might print sensitive values.
  headers = {
    Accept        = "application/json"
    Authorization = data.ibm_iam_auth_token.token_data.iam_access_token
    Content-Type  = "application/json"
  }
}
```

 This configuration block is added to the `providers.tf` file in the [example](#examples) that is available in this module.

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

For more information about the access you need to run all the GoldenEye modules, see [GoldenEye IAM permissions](https://github.ibm.com/GoldenEye/documentation/blob/master/goldeneye-iam-permissions.md).

<!-- BEGIN EXAMPLES HOOK -->
## Examples

- [ Default example](examples/default)
<!-- END EXAMPLES HOOK -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.49.0 |
| <a name="requirement_restapi"></a> [restapi](#requirement\_restapi) | >= 1.18.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [restapi_object.secrets_manager_private_certificate](https://registry.terraform.io/providers/Mastercard/restapi/latest/docs/resources/object) | resource |
| [ibm_secrets_manager_secret.secrets_manager_secret](https://registry.terraform.io/providers/ibm-cloud/ibm/latest/docs/data-sources/secrets_manager_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cert_alt_names"></a> [cert\_alt\_names](#input\_cert\_alt\_names) | The certificates alternate names (comma separated) | `string` | `""` | no |
| <a name="input_cert_common_name"></a> [cert\_common\_name](#input\_cert\_common\_name) | The certificates common name | `string` | n/a | yes |
| <a name="input_cert_description"></a> [cert\_description](#input\_cert\_description) | The certificates description | `string` | `""` | no |
| <a name="input_cert_ip_sans"></a> [cert\_ip\_sans](#input\_cert\_ip\_sans) | The certificates IP sans | `string` | `""` | no |
| <a name="input_cert_name"></a> [cert\_name](#input\_cert\_name) | The name of the certificate in Secrets Manager | `string` | n/a | yes |
| <a name="input_cert_secrets_group_id"></a> [cert\_secrets\_group\_id](#input\_cert\_secrets\_group\_id) | The id of Secrets Manager secret group to store the certificate in | `string` | `""` | no |
| <a name="input_cert_template"></a> [cert\_template](#input\_cert\_template) | The name of the certificate template to use | `string` | `""` | no |
| <a name="input_cert_ttl"></a> [cert\_ttl](#input\_cert\_ttl) | The certificates ttl | `string` | `""` | no |
| <a name="input_cert_uri_sans"></a> [cert\_uri\_sans](#input\_cert\_uri\_sans) | The certificates URI sans | `string` | `""` | no |
| <a name="input_secrets_manager_guid"></a> [secrets\_manager\_guid](#input\_secrets\_manager\_guid) | The Secrets Manager GUID | `string` | n/a | yes |
| <a name="input_secrets_manager_region"></a> [secrets\_manager\_region](#input\_secrets\_manager\_region) | The region the Secrets Manager instance is in | `string` | n/a | yes |
| <a name="input_service_endpoints"></a> [service\_endpoints](#input\_service\_endpoints) | The service endpoint type to communicate with the provided secrets manager instance. Possible values are `public` or `private` | `string` | `"public"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secret_crn"></a> [secret\_crn](#output\_secret\_crn) | Private certificates secrets manager secret CRN |
| <a name="output_secret_id"></a> [secret\_id](#output\_secret\_id) | Private certificates secrets manager secret ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- BEGIN CONTRIBUTING HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in the GoldenEye [issues](https://github.ibm.com/GoldenEye/issues) repo.See [Report a Bug or Create Enhancement Request](https://github.ibm.com/GoldenEye/documentation/blob/master/issues.md).

To set up your local development environment, see [Local development setup](https://github.ibm.com/GoldenEye/documentation/blob/master/local-dev-setup.md) in the project documentation.
<!-- Source for this readme file: https://github.com/terraform-ibm-modules/common-dev-assets/tree/main/module-assets/ci/module-template-automation -->
<!-- END CONTRIBUTING HOOK -->
