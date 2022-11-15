##############################################
# Get latest Ubuntu Linux AMI with Terraform #
##############################################

# Get latest Ubuntu Linux Focal Fossa 20.04 AMI
data "aws_ami" "ubuntu-linux-2004" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# output Ubuntu AMI IDs

output "ubuntu_2004_ami_id" {
  value = data.aws_ami.ubuntu-linux-2004.id
}
