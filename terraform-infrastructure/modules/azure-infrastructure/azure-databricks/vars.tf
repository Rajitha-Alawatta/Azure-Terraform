variable "environment" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

variable "sku" {
  type    = string
  default = "premium"
}

variable "virtual_network_id" {
  type = string
}

variable "private_subnet_name" {
  type = string
}

variable "public_subnet_name" {
  type = string
}

variable "private_subnet_nsg_association_id" {
  type = string
}

variable "public_subnet_nsg_association_id" {
  type = string
}
