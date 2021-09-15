resource "aws_instance" "db-01" {
  instance_type               = "m5a.large"
  ami                         = "ami-07b04ee3cf883103f"
  key_name                    = "ubuntu"
  subnet_id                   = aws_subnet.private-a.id
  disable_api_termination     = true
  associate_public_ip_address = false
  ebs_optimized               = true

  root_block_device {
    delete_on_termination = true
    volume_size           = "200"
    volume_type           = "gp2"
  }

  tags = {
    Name     = "db-01"
  }

  vpc_security_group_ids = [ aws_security_group.db.id ]
}

resource "aws_instance" "db-02" {
  instance_type               = "m5a.large"
  ami                         = "ami-07b04ee3cf883103f"
  key_name                    = "ubuntu"
  subnet_id                   = aws_subnet.private-b.id
  disable_api_termination     = true
  associate_public_ip_address = false
  ebs_optimized               = true

  root_block_device {
    delete_on_termination = true
    volume_size           = "200"
    volume_type           = "gp2"
  }

  tags = {
    Name     = "db-02"
  }

  vpc_security_group_ids = [ aws_security_group.db.id ]
}

resource "aws_instance" "db-03" {
  instance_type               = "m5a.large"
  ami                         = "ami-07b04ee3cf883103f"
  key_name                    = "ubuntu"
  subnet_id                   = aws_subnet.private-c.id
  disable_api_termination     = true
  associate_public_ip_address = false
  ebs_optimized               = true

  root_block_device {
    delete_on_termination = true
    volume_size           = "200"
    volume_type           = "gp2"
  }

  tags = {
    Name     = "db-03"
  }

  vpc_security_group_ids = [ aws_security_group.db.id ]
}

resource "aws_instance" "proxy" {
  instance_type               = "t3.medium"
  ami                         = "ami-0bddf91959c03a187"
  key_name                    = "ubuntu"
  subnet_id                   = aws_subnet.public-a.id
  disable_api_termination     = true
  associate_public_ip_address = false
  ebs_optimized               = true

  root_block_device {
    delete_on_termination = true
    volume_size           = "50"
    volume_type           = "gp2"
  }

  tags = {
    Name     = "proxy"
  }

  vpc_security_group_ids = [ aws_security_group.proxy.id ]
}
