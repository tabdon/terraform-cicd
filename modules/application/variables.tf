variable "project" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "private_subnet" {
  type = list(any)
}

variable "public_subnet" {
  type = string
}
