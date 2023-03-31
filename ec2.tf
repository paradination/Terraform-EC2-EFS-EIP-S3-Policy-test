#creating ec2 for project
resource "aws_instance" "ec2" {
  
  ami = var.ami_id["linux"]
  instance_type = "t2.micro"
  subnet_id = aws_subnet.main-subnet.id
  security_groups = [aws_security_group.sg.id]
  key_name = aws_key_pair.deployer.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name   = "NetSPI"
    Project = "NetSPI_VPC"
  }
}

#Associate EIP with EC2 Instance
resource "aws_eip_association" "eip-association" {
  instance_id   = aws_instance.ec2.id
  allocation_id = "eipalloc-020a23a6c96df045e"
}
