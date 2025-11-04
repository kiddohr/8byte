variable "cidr" {
  
}

variable "public_cidr" {
  
}

variable "private_cidr" {
  
}

variable "image_uri" {
  
}

variable "db_username" {}

variable "db_password" {
    sensitive = true
}

variable "db_instance_class" {
}

variable "db_allocated_storage" {
}