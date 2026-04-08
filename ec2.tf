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

dnf update -y
dnf install -y docker git

systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

mkdir -p /opt/5apps
cd /opt/5apps

git clone https://github.com/RareBreedxx/5apps.git app
cd app

curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

docker compose up -d
EOF
 user_data_replace_on_change = true
 
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
  user_data_replace_on_change = true 

  tags = {
    Name = "web-server-2"
  }
}
