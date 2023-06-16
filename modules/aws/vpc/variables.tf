variable "vpc_cidr" {
    type = string
}

variable "vpc_name" {
    type = string
}

variable "tags" {
  type = map(string)
}

variable "subnets" {
    type = list(map(string))
}