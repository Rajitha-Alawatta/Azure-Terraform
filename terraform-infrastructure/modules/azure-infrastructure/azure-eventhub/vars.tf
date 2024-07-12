variable "environment" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

variable "capacity" {
  type    = number
  default = 2
}

variable "max_throughput_units" {
  type    = number
  default = 10
}

variable "partition_count" {
  type    = number
  default = 4
}

variable "message_retention" {
  type    = number
  default = 7
}
