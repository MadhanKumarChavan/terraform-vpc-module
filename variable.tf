#project name and environment is must that can be given by module user
variable "project_name" {
    type = string 
}
variable "environment" {
    type = string 
    default = "dev"
}

variable "common_tags" {
    type = map 
   
}

####vpc tags######
variable "cidr_block" {
    type = string
    default = "10.0.0.0/16"
  
}
variable "enable_dns_hostnames" {
    type = bool
    default = "true"
  
}
variable "vpc_tags" {
    type = map 
    default = {}
}

####internetgateway tags######
variable "igw_tags" {
   type = map
    default = {} 
}

#### public subnets info######
variable "public_subnet_cidrs" {

  type = list
  validation {
    condition =  length(var.public_subnet_cidrs) == 2
    error_message = "please provide 2 cdir blocks"
  }
}

variable "public_subnet_cidr_tags" {

  type = map
    default = {} 
}

#### private subnets info######
variable "private_subnet_cidrs" {

  type = list
  validation {
    condition =  length(var.private_subnet_cidrs) == 2
    error_message = "please provide 2 cdir blocks"
  }
}

variable "private_subnet_cidr_tags" {

  type = map
    default = {} 
}
#### database subnets info######
variable "database_subnet_cidrs" {

  type = list
  validation {
    condition =  length(var.database_subnet_cidrs) == 2
    error_message = "please provide 2 cdir blocks"
  }
}

variable "database_subnet_cidr_tags" {

  type = map
    default = {} 
}

variable "natgatway_tags" {

  type = map
    default = {} 
}

variable "publicroutetables_tags" {

  type = map
    default = {} 
}

variable "privateroutetables_tags" {

  type = map
    default = {} 
}
variable "databaseroutetables_tags" {

  type = map
    default = {} 
}
