provider "azurerm" {
  version = "1.36.1"
}

locals {
  # list of the thumbprints of the SSL certificates that should be accepted by the API (gateway)
  mockbackend_thumbprints_in_quotes         = "${formatlist("&quot;%s&quot;", var.mockbackend_api_gateway_certificate_thumbprints)}"
  mockbackend_thumbprints_in_quotes_str     = "${join(",", local.mockbackend_thumbprints_in_quotes)}"
  mockbackend_api_url                       = "http://payment-api-${var.env}.service.core-compute-${var.env}.internal"

}
data "azurerm_key_vault" "payment_key_vault" {
  name                = "hmi-${var.env}"
  resource_group_name = "hmi-${var.env}"
}
