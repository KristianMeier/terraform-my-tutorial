resource "aws_vpc" "mtc_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "mtc_public_subnet" {
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-north-1a"

  tags = {
    Name = "dev-public"
  }
}

resource "aws_internet_gateway" "mtc_internet_gateway" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "mtc_public_rt" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "dev-public-rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.mtc_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mtc_internet_gateway.id
}

resource "aws_route_table_association" "mtc_public_assoc" {
  subnet_id      = aws_subnet.mtc_public_subnet.id
  route_table_id = aws_route_table.mtc_public_rt.id
}

resource "aws_security_group" "mtc_sg" {
  name        = "dev_sg"
  description = "dev security group"
  vpc_id      = aws_vpc.mtc_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "mtc_auth" {
  key_name   = "mtckey"
  public_key = file("~/.ssh/mtckey.pub")
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "krille-unikt-navn-hihi" # Change this to a variable. Måske
}

resource "aws_iam_policy" "s3_read_policy" {
  name        = "S3ReadPolicy"
  description = "My policy that grants read access to a specific S3 bucket"

  policy = file("policies/s3_policy.tf.json")
}

resource "aws_iam_role" "ec2_s3_read_role" {
  name = "EC2S3ReadRole"
  assume_role_policy = file("policies/assume_role_policy.tf.json")
}

resource "aws_iam_role_policy_attachment" "attach_s3_read_policy" {
  policy_arn = aws_iam_policy.s3_read_policy.arn
  role       = aws_iam_role.ec2_s3_read_role.name
}

resource "aws_iam_instance_profile" "ec2_s3_read_profile" {
  name = "EC2S3ReadProfile"
  role = aws_iam_role.ec2_s3_read_role.name
}

resource "aws_instance" "dev_node" {
  ami                    = data.aws_ami.server_ami.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.mtc_auth.key_name
  vpc_security_group_ids = [aws_security_group.mtc_sg.id]
  subnet_id              = aws_subnet.mtc_public_subnet.id
  user_data              = file("scripts/userdata.sh")

  iam_instance_profile = aws_iam_instance_profile.ec2_s3_read_profile.name

  root_block_device {
    volume_size = var.volume_size // 16 max for free tier
  }

  tags = {
    Name = "dev-node"
  }
}