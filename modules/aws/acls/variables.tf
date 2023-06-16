variable "vpc_id" {
    type = string
}

variable "tags" {
    type = map(string)
}

variable "subnet_ids" {
    type = list(string)
}

variable "acl_info" {
    type = any
}

variable "subnet_info" {
    type = any
}