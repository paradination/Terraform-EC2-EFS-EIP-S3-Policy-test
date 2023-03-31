#outputs

#S3 Bucket ID
output "s3_id" {
    value = aws_s3_bucket.s3.id
}

#EFS volume ID
output "efs_id" {
    value = aws_efs_file_system.efs.id
}
 

#EC2 instance ID
output "ec2_id" {
    value = aws_instance.ec2.id
}

#Security group ID
output "sg_id" {
    value = aws_security_group.sg.id
}

#Subnet ID
output "subnet_id" {
  value = aws_subnet.main-subnet.id
}
