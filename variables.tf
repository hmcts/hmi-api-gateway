variable "product" {
  type    = "string"
  default = "hmi"
}

variable "location" {
  type    = "string"
  default = "UK South"
}

variable "env" {
  type = "string"
}

variable "tenant_id" {
  description = "(Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. This is usually sourced from environemnt variables and not normally required to be specified."
}

# thumbprint of the SSL certificate for hmi mockbackend api
variable mockbackend_api_gateway_certificate_thumbprints {
  type = "list"
  default = []
}