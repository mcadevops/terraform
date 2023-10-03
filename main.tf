terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
provider "aws" {
  access_key="var.accesskey"
  secret_key= "var.secretkey"
  region     = "us-east-1"
}
resource "aws_instance" "ownec2" {
  ami           = "ami-03a6eaae9938c858c"
  instance_type = "t2.micro"
  vpc_security_group_ids=[aws_security_group.ownsg.id]
  key_name="tf-key-pair"
tags={
 Name="terraform-plan"
}
}
resource "aws_security_group" "ownsg" {
 name="ownsg"
ingress {
 from_port=80
 to_port=80
protocol="tcp"
cidr_blocks= ["0.0.0.0/0"]

}
}
resource "aws_key_pair" "tf-key-pair-demo" {
key_name = "tf-key-pair"
public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
algorithm = "RSA"
rsa_bits  = 4096
}
resource "local_file" "tf-key" {
content  = tls_private_key.rsa.private_key_pem
filename = "tf-key-pair-demo"
}
