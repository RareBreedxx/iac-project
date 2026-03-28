data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "web1" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              dnf install -y nginx
              systemctl enable nginx
              systemctl start nginx
              echo "Hello from web-server-1" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = "web-server-1"
  }
}

resource "aws_instance" "web2" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public2.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              dnf install -y nginx
              systemctl enable nginx
              systemctl start nginx
              echo "Hello from web-server-2" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = "web-server-2"
  }
}
