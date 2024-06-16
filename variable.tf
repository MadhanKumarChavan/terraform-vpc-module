#project name and environment is must that can be given by module user
variable "project_name" {
    type = string 
    default = "expense"
}
variable "environment" {
    type = string 
    default = "dev"
}

variable "common_tags" {
    type = map 
   
}

####vpc tags######
variable "vpc_cidr" {
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
variable "database_subnet_group_tags" {
    type = map
    default = {}
}

variable "nat_gatway_tags" {

  type = map
    default = {} 
}

variable "public_route_tables_tags" {

  type = map
    default = {} 
}

variable "private_route_tables_tags" {

  type = map
    default = {} 
}
variable "database_route_tables_tags" {

  type = map
    default = {} 
}
#### Peering ####
variable "is_peering_required" {
  type = bool
  default = false
}

variable "acceptor_vpc_id" {
  type = string
  default = ""
}

variable "vpc_peering_tags" {
  type = map
  default = {}
}