variable "region" {
    type = string
    default = "us-east-2"
}

variable "vpc_name" {
    type = string
    default = "HIPPA"
}

variable "tags" {
    type = map(string)
    default = {
      Terraform : "True"
      Owner : "ITOP"
    }
}

variable "subnets" {
    type = list(map(string))
}

variable "vpc_cidr" {
    type = string
}

variable "public_acls" {
    type = any
}

variable "security_groups" {
    type = list(any)
}
variable "assume_role" {
    type = string
}

variable "shared_credentials_files" {
    type = list(string)
    default = ["~/.aws/credentials"]
}
variable "shared_config_files" {
    type = list(string)
    default = ["~/.aws/config"]
}

variable "profile" {
    type = string
}