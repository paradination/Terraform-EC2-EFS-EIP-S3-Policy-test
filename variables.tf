#for VPC and Subnets

variable "cidr" {
    default = "172.16.0.0/24"
}

variable "dns-hostname" {
    type = list
    default = [true, false]
}
variable "dns-support" {
    type = list
    default = [true, false]
}

variable "subnetcidr" {
    default = "172.16.0.0/26"
}

variable "name" {
    type = list
    default = ["NetSPI"]
}

#For ec2
variable "ami_id" {
    type = map
    default = {
        "linux": "ami-00c39f71452c08778"
    }
}

variable "port-sg" {
    type = list 
    default = ["22", "80", "443", "2049"]
}
