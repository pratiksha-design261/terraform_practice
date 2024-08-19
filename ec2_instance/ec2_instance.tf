# new genrated ssh key added
resource "aws_key_pair" "my_ssh_key"{

  key_name = "terra-key-auto-generated"
  public_key = file("/home/ubuntu/.ssh/terra-key-auto.pub")

}

# added default vpc group
resource "aws_default_vpc" "default_vpc"{
}

# added inbound and outbound rules for security group
resource "aws_security_group" "my_security_group"{

  name = "My-auto-sg"
  description = "security group generated automatically using .tf file"
  vpc_id = aws_default_vpc.default_vpc.id
  ingress {

    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "this is for ssh Access"

  }

 ingress {

    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "this is for http Access"

  }


  egress{

    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "this is for otside access for instance"

  }

}

# created instance
resource "aws_instance" "my_instance" {
#how many instance we need to add
  #count = 1
  tags = {

#name of instance
    Name = "my-auto-instance"

   }

  ami = "ami-0862be96e41dcbf74"
  instance_type = "t2.micro"
# using interpollation newly created key is attached to instance
  key_name = aws_key_pair.my_ssh_key.key_name
# attached security group
  security_groups = [aws_security_group.my_security_group.name]   # as multople security groups can be attcah to 1 inst/nance so we are using []

}

# this will set the state for newly created instances
resource "aws_ec2_instance_state" "my_instance-state" {

  instance_id = aws_instance.my_instance.id
  state = "stopped"

}

# the value can be display in output
output "my_ec2_ip" {

  value = aws_instance.my_instance.public_ip

}
