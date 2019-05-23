# Specify the provider and access details
provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "terraform-example" {
  key_name = "ssh-key"
  public_key = "${file(".aws/ssh-key.pub")}"
}

resource "aws_security_group" "terraform-example" {
  name = "terraform-example"

  # Open up incoming ssh port
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Open up incoming traffic to port 8888 used by Jupyter Notebook
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Open up outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "terraform-example" {

  ami           = "ami-43a15f3e"
  instance_type = "t2.micro"

  tags {
    Name = "terraform-example"
  }

  # Security groups
  vpc_security_group_ids = ["${aws_security_group.terraform-example.id}"]

  # Write public IP into local
  provisioner "local-exec" {
    command = "echo ${aws_instance.terraform-example.public_ip} > ip_address.txt"
  }

  # SSH key
  key_name = "${aws_key_pair.terraform-example.key_name}"

}

output "node_dns_name" {
  value = "${aws_instance.terraform-example.public_dns}"
}