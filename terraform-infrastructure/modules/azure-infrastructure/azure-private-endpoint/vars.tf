variable "environment" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "private_connection_id" {
  type = string
}

variable "private_dns_zone_id" {
  type = list(string)
}