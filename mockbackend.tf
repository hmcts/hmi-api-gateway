module "hmi-mockbackend-product" {
  source = "git@github.com:hmcts/cnp-module-api-mgmt-product?ref=master"

  api_mgmt_name = "core-api-mgmt-${var.env}" # name of the API Management Service instance being used
  api_mgmt_rg   = "core-infra-${var.env}" # resource group to which APIM Service instance belongs
  subscription_required = false
  approval_required     = false
  subscriptions_limit   = "0"

  name = "hmi"
}

module "hmi-mockbackend-api" {
  source        = "git@github.com:hmcts/cnp-module-api-mgmt-api?ref=master" #resource "azurerm_api_management_api" "api" defined in this repository
  api_mgmt_name = "core-api-mgmt-${var.env}" # name of the API Management Service instance being used
  api_mgmt_rg   = "core-infra-${var.env}" # resource group to which APIM Service instance belongs
  revision      = "1"
  service_url   = "${local.mockbackend_api_url}"
  product_id    = "${module.hmi-mockbackend-product.product_id}"
  name          = "mockbackend-api"
  display_name  = "Mockbackend API"
  path          = "mockbackend-api"
  # following is the api template. We need to create one for our backend api which we want to expose through the gateway
  swagger_url   = "https://raw.githubusercontent.com/hmcts/reform-api-docs/master/docs/specs/ccpay-payment-app.payments.json" # Do we need this if we are enabling mocking
}

# TODO: look at why this is generating a new template each time
data "template_file" "mockbackend_policy_template" {
  template = "${file("${path.module}/templates/hmi-mockbackend-api-policy.xml")}"
}

module "hmi-mockbackend-policy" {
  source = "git@github.com:hmcts/cnp-module-api-mgmt-api-policy?ref=master"

  api_mgmt_name = "hmi-${var.env}"
  api_mgmt_rg   = "hmi-${var.env}"

  api_name               = "${module.hmi-mockbackend-api.name}"
  api_policy_xml_content = "${data.template_file.mockbackend_policy_template.rendered}"
}