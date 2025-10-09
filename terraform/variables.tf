
# networking


variable "public_subnet1" {
  description = "CIDR Block for Public Subnet 1"
  default     = "subnet-98dba5e2"
}

variable "public_subnet2" {
  description = "CIDR Block for PublicSubnet 1"
  default     = "subnet-4356da0f"
}

variable "cluster_name" {
  type = string
  default = "my-eks-cluster1"
 }
