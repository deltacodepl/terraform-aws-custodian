###################################
## Virtual Machine Module - Main ##
###################################

# Create Elastic IP for the EC2 instance
# resource "aws_eip" "linux-eip" {
#   vpc  = true
#   tags = {
#     Name        = "${lower(var.app_name)}-${var.app_environment}-linux-eip"
#     Environment = var.app_environment
#   }
# }

module "iam" {
  source   = "./modules/iam"
  app_name = var.app_name
}

module "s3" {
  source   = "./modules/s3"
  org_name = var.org_name
}

module "cloudtrial" {
  source            = "./modules/cloudtrial"
  cloudtrail_bucket = module.s3.cloudtrail_bucket # module composition https://developer.hashicorp.com/terraform/language/modules/develop/composition
  cloudtrail_role   = module.iam.execution_role_arn
  org_name          = var.org_name
  depends_on = [
    module.s3
  ]
}

module "sqs" {
  source = "./modules/sqs"
}

# module "aws_cloudtrail" {
#     source             = "trussworks/cloudtrail/aws"
#     s3_bucket_name     = "main-cloudtrail-logs"
#     log_retention_days = 90
# }

# Create EC2 Instance
resource "aws_instance" "linux-server" {
  ami                         = data.aws_ami.ubuntu-linux-2004.id
  instance_type               = var.linux_instance_type
  subnet_id                   = aws_subnet.public-subnet.id
  vpc_security_group_ids      = [aws_security_group.aws-linux-sg.id]
  associate_public_ip_address = var.linux_associate_public_ip_address
  source_dest_check           = false
  key_name                    = aws_key_pair.key_pair.key_name
  user_data                   = file("install-custodian.sh")

  # root disk
  root_block_device {
    volume_size           = var.linux_root_volume_size
    volume_type           = var.linux_root_volume_type
    delete_on_termination = true
    encrypted             = true
  }

}

# Associate Elastic IP to Linux Server
# resource "aws_eip_association" "linux-eip-association" {
#   instance_id   = aws_instance.linux-server.id
#   allocation_id = aws_eip.linux-eip.id
# }

# Define the security group for the Linux server
resource "aws_security_group" "aws-linux-sg" {
  name        = "${lower(var.app_name)}-${var.app_environment}-linux-sg"
  description = "Allow incoming HTTP connections"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.http.myip.response_body}/32"]
    description = "Allow incoming SSH connections"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
