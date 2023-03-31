
#creating EFS volume 

resource "aws_efs_file_system" "efs" {
  creation_token = "project"

  tags = {
    Name   = "NetSPI"
    Project = "NetSPI_EFS"
  }
}

# Creating Mount target of EFS
resource "aws_efs_mount_target" "mount" {
file_system_id = aws_efs_file_system.efs.id
subnet_id      = aws_subnet.main-subnet.id
security_groups = [aws_security_group.sg.id]
}

resource "aws_efs_access_point" "test" {
  file_system_id = aws_efs_file_system.efs.id
}

#mounting on boot to /data/test
# Creating Mount Point for EFS
resource "null_resource" "configure_nfs" {
depends_on = [aws_efs_mount_target.mount]
connection {
type     = "ssh"
user     = "ec2-user"
private_key = tls_private_key.my_key.private_key_pem
host     = "54.235.138.246"
 }

provisioner "remote-exec" {
inline = [
"sudo yum install nfs-utils -y -q ", # Amazon ami has pre installed nfs utils
# Mounting Efs 
"sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.efs.dns_name}:/  /data/test",
# Making Mount Permanent
"echo ${aws_efs_file_system.efs.dns_name}:/ /data/test nfs4 defaults,_netdev 0 0  | sudo cat >> /etc/fstab " ,
"sudo chmod go+rw /data/test",
  ]
 }
}