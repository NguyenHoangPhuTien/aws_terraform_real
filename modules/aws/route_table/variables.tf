variable "tags" {
  type = map(string)
}

variable "vpc_id" {
    type = string
}

variable "gateway_id" {
    type = string
}

variable "nat_id" {
    type = string
}

variable "name" {
    type = string
}

variable "type" {
    type = string

    validation {
        condition = contains(["private", "public"], var.type)
        error_message = "Valid values for type are (private, public)"
    }
}

variable "subnet_ids" {
  type = list(string)
}

variable "subnet_info" {
  type = any
}