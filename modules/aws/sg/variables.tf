variable "security_groups" {
    type = any
}

variable "vpc_id" {
    type = string
}

variable "tags" {
    type = map(string)
}