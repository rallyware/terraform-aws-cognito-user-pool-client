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
