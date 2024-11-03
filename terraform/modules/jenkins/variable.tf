variable "cluster_name" {
  description = "name of the cluster, will be the name of the VPC,should be unique"
  type        = string
}

variable "created_by" {
  description = "created by quickops metadata"
  type        = string
}

variable "aws_region" {
  description = "your aws region"
  type        = string
}

variable "jenkins_ec2_size" {
  description = "your jenkins ec2 size"
  type        = string
}


variable "ami_id" {
  description = "ami id of your ec2 instance"
  type        = string
  default     = "ami-0dee22c13ea7a9a67"
}

variable "jenkins_subnet_id" {
  description = "subnet id for the jenkins"
  type        = string

}

variable "jenkins_vpc_id" {
  description = "vpc for the jenkins"
  type        = string
}