resource "aws_key_pair" "mtc_auth" {
  key_name   = "mtckey"
  public_key = file("~/.ssh/mtckey.pub")
}

resource "aws_instance" "dev_node" {
  ami                    = data.aws_ami.server_ami.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.mtc_auth.key_name
  vpc_security_group_ids = [aws_security_group.mtc_sg.id]
  subnet_id              = aws_subnet.mtc_public_subnet.id
  user_data              = file("scripts/userdata.sh")

  iam_instance_profile = aws_iam_instance_profile.ec2_s3_access_profile.name

  root_block_device {
    volume_size = var.volume_size // 16 max for free tier
  }

  tags = {
    Name = "dev-node"
  }
}