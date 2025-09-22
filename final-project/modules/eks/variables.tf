variable "cluster_name"        { type = string }
variable "cluster_version"     { type = string }
variable "vpc_id"              { type = string }
variable "public_subnet_ids"   { type = list(string) }

variable "ng_instance_types" {
  type    = list(string)
  default = ["t3.micro"]
}
variable "ng_desired_size"     { type = number }
variable "ng_min_size"         { type = number }
variable "ng_max_size"         { type = number }
