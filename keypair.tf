# Generate new private key
resource "tls_private_key" "my_key" {
algorithm = "RSA"
}
# Generate a key-pair with above key
resource "aws_key_pair" "deployer" {
key_name   = "efs-key"
public_key = tls_private_key.my_key.public_key_openssh
}
