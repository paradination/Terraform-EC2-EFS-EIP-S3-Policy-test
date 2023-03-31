#policy for ec2 to write data on EFS

# # Creating the AWS EFS System policy to transition files into and out of the file system.
data "aws_iam_policy_document" "policy" {
  statement {
    sid    = "ExampleStatement01"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientWrite",
    ]

    resources = [aws_efs_file_system.efs.arn]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["true"]
    }
  }
}

resource "aws_efs_file_system_policy" "policy" {
  file_system_id                     = aws_efs_file_system.efs.id
  bypass_policy_lockout_safety_check = true
  policy                             = data.aws_iam_policy_document.policy.json
}


resource "aws_iam_role_policy" "s3_policy" {
  name = "s3_write_policy"
  role = aws_iam_role.ec2_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

        {
            Sid = "VisualEditor0",
            Effect = "Allow",
            Action = "s3:*Object",
            Resource = [
                "${aws_s3_bucket.s3.arn}",
                "${aws_s3_bucket.s3.arn}/*"
            ]
        },
        {
            Sid = "VisualEditor1",
            Effect = "Allow",
            Action = "s3:List*",
            Resource =  [
                "${aws_s3_bucket.s3.arn}",
                "${aws_s3_bucket.s3.arn}/*"
            ]
        },
    ]
  })
}

#role assuming policies

resource "aws_iam_role" "ec2_role" {
    name = "ec2_role"
    #Terraform expresssion result to valid JSON syntax
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid = ""
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            },
        ] 
    })

}

#attach role to an instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
    name = "ec2_profile"
    role = aws_iam_role.ec2_role.name
}

#attaching roles to the policy
resource "aws_iam_policy_attachment" "efs_write_policy" {
    name = "efs_write_attachment"
    roles = [aws_iam_role.ec2_role.name]
    policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientReadWriteAccess"
}
