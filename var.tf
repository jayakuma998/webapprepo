
variable "access_key" {
  description = "This is the variable for the access key id"
  type        = string
}

variable "secret_key" {
  description = " this is the variable for secret key"
  type        = string
}

variable "region" {
  description = "this is the variable for region"
  type        = string
}

variable "vpccidr" {

  description = "cidr block for projectvpc"
  type        = string

}

variable "dnshostname" {

  description = "enable dns hostnames"
  type        = bool
}

variable "projectvpctags" {

  type = map(string)

}

## variable for igw-tag 

variable "igw-tag" {
  description = "This is the variable for igw tags"
  type = map(string)  
}

variable "pubsubcidr1" {
  description = "information public subnet1 cidr "
  type = string
}

variable "az1" {
  description = "information for aavaibility zone 1"
  type = string
}

variable "pubsub1tags" {
  description = "tags for the public subnet 1"
  type = map(string)
}

variable "pubsubcidr2" {
  description = "information public subnet2 cidr "
  type = string
}

variable "az2" {
  description = "information for aavaibility zone 2"
  type = string
}

variable "pubsub2tags" {
  description = "tags for public subnet 2"
  type = map(string)
}
variable "privsubcidr1" {
  description = " cidr block info for private subnet 1"
  type = string
}

variable "privsub1tags" {
  description = "tags for priv subnet 1"
  type = map(string)
}

variable "privsubcidr2" {
  description = "cidr for private 2 subnet"
  type = string
}

variable "privsub2tags" {
  
  description = " tags for private subnet 2"
  type = map(string)
}

# variable "bucketname" {
#   type = string
# }

variable "webserversgname" {
  type = string 
}

variable "allow_http_cidr_myip" {
  type = string
  description = "Allow traffic from my house location"
}

# webserver variables

variable "ami" {
  type = string
}

variable "webserverkeyname" {
  type = string 
}

variable "instance_type" {
  type = string
}

variable "webservertags" {
  type = map(string)
}

#dbserver variables

variable "dbami" {
  type = string
}

variable "dbserverkeyname" {
  type = string
}

variable "dbservertags" {
  type = map(string)
}

variable "dbserversgname" {
  type = string
}