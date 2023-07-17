# terraform-module-template
Terraform module to priovision and manage `Cognito` client.

<!-- BEGIN_TF_DOCS -->
## Usage
```hcl
module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  name      = "aweasome"
  stage     = "production"
  namespace = "rlw"

}

module "cognito" {
  source  = "rallyware/cognito-user-pool/aws"
  version = "0.1.0"

  identity_providers = [
    {
      name            = "Google"
      type            = "Google"
      idp_identifiers = []

      provider_details = {
        authorize_scopes              = "openid profile email"
        client_id                     = "GOOGLE_CLIENT_ID"
        client_secret                 = "GOOGLE_CLIENT_SECRET"
        attributes_url                = "https://people.googleapis.com/v1/people/me?personFields="
        attributes_url_add_attributes = "true"
        authorize_url                 = "https://accounts.google.com/o/oauth2/v2/auth"
        oidc_issuer                   = "https://accounts.google.com"
        token_request_method          = "POST"
        token_url                     = "https://www.googleapis.com/oauth2/v4/token"
      }

      attribute_mapping = {
        email       = "email"
        family_name = "family_name"
        given_name  = "given_name"
        name        = "name"
        picture     = "picture"
        username    = "sub"
      }
    }
  ]

  groups = [
    {
      name       = "admin"
      precedence = 1
    },
    {
      name       = "dev"
      precedence = 10
    }
  ]

  context = module.label.context

}

module "cognito_client" {
  source = "../../"

  user_pool_id                 = module.cognito.id
  supported_identity_providers = ["Google"]
  callback_urls                = ["https://grafana.local/login/generic_oauth"]

  context    = module.label.context
  attributes = ["grafana"]
}
```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 2.0 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4 |
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |
## Resources

| Name | Type |
|------|------|
| [aws_cognito_user_pool_client.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client) | resource |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_user_pool_id"></a> [user\_pool\_id](#input\_user\_pool\_id) | User pool the client belongs to. | `string` | n/a | yes |
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_allowed_oauth_flows"></a> [allowed\_oauth\_flows](#input\_allowed\_oauth\_flows) | List of allowed OAuth flows (code, implicit, client\_credentials). | `list(string)` | <pre>[<br>  "code",<br>  "implicit"<br>]</pre> | no |
| <a name="input_allowed_oauth_flows_user_pool_client"></a> [allowed\_oauth\_flows\_user\_pool\_client](#input\_allowed\_oauth\_flows\_user\_pool\_client) | Whether the client is allowed to follow the OAuth protocol when interacting with Cognito user pools. | `bool` | `true` | no |
| <a name="input_allowed_oauth_scopes"></a> [allowed\_oauth\_scopes](#input\_allowed\_oauth\_scopes) | List of allowed OAuth scopes (phone, email, openid, profile, and aws.cognito.signin.user.admin). | `list(string)` | <pre>[<br>  "email",<br>  "openid",<br>  "profile",<br>  "aws.cognito.signin.user.admin"<br>]</pre> | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_callback_urls"></a> [callback\_urls](#input\_callback\_urls) | List of allowed callback URLs for the identity providers. | `list(string)` | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "unset"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_explicit_auth_flows"></a> [explicit\_auth\_flows](#input\_explicit\_auth\_flows) | List of authentication flows (ADMIN\_NO\_SRP\_AUTH, CUSTOM\_AUTH\_FLOW\_ONLY, USER\_PASSWORD\_AUTH, ALLOW\_ADMIN\_USER\_PASSWORD\_AUTH, ALLOW\_CUSTOM\_AUTH, ALLOW\_USER\_PASSWORD\_AUTH, ALLOW\_USER\_SRP\_AUTH, ALLOW\_REFRESH\_TOKEN\_AUTH). | `list(string)` | <pre>[<br>  "ALLOW_REFRESH_TOKEN_AUTH",<br>  "ALLOW_USER_SRP_AUTH",<br>  "ALLOW_CUSTOM_AUTH"<br>]</pre> | no |
| <a name="input_generate_secret"></a> [generate\_secret](#input\_generate\_secret) | Should an application secret be generated. | `bool` | `true` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_logout_urls"></a> [logout\_urls](#input\_logout\_urls) | List of allowed logout URLs for the identity providers. | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_prevent_user_existence_errors"></a> [prevent\_user\_existence\_errors](#input\_prevent\_user\_existence\_errors) | Choose which errors and responses are returned by Cognito APIs during authentication, account confirmation, and password recovery when the user does not exist in the user pool. Possible values: ENABLED, LEGACY | `string` | `"ENABLED"` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_supported_identity_providers"></a> [supported\_identity\_providers](#input\_supported\_identity\_providers) | List of provider names for the identity providers that are supported on this client. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |
| <a name="input_token_ttl"></a> [token\_ttl](#input\_token\_ttl) | The token TTL. Allowed values are number of time units (s, m, h, d). | <pre>object({<br>    id      = optional(string, "1h")<br>    refresh = optional(string, "1h")<br>    access  = optional(string, "1h")<br>  })</pre> | `{}` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_secret"></a> [client\_secret](#output\_client\_secret) | Client secret of the user pool client. |
| <a name="output_id"></a> [id](#output\_id) | ID of the user pool client. |
<!-- END_TF_DOCS -->

## License
The Apache-2.0 license