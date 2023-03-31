#creating s3 bucket with private access

resource "aws_s3_bucket" "s3" {
  bucket = "netspi-kenny-private-bucket"

  tags = {
    Name   = "NetSPI"
    Project = "NetSPI_Bucket"
  }
}

resource "aws_s3_bucket_acl" "private" {
  bucket = aws_s3_bucket.s3.id
  acl    = "private"
}
