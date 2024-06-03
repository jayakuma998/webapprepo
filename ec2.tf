# create the web server instance. 

# create web server security group

resource "aws_security_group" "webserver-sg" {
  name        = var.webserversgname
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.projectvpc.id

   ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.allow_http_cidr_myip]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# create db server security group

# Create the DB server security group
resource "aws_security_group" "dbserver-sg" {
  name        = var.dbserversgname
  description = "Allow MySQL traffic from web server and all outbound traffic"
  vpc_id      = aws_vpc.projectvpc.id

  # No changes needed in the egress rule
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# Changed to aws_security_group_rule for better clarity
resource "aws_security_group_rule" "allow_mysql_traffic_from_webserver" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.dbserver-sg.id
  source_security_group_id = aws_security_group.webserver-sg.id  # Changed to source_security_group_id
}


# create webserver security group rule to allow http trafic from internet

resource "aws_vpc_security_group_ingress_rule" "allow_http_traffic_myip" {
  security_group_id = aws_security_group.webserver-sg.id
  cidr_ipv4         = var.allow_http_cidr_myip
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

#create webswever instance 

resource "aws_instance" "webserver" {
  ami = var.ami
  key_name = var.webserverkeyname
  instance_type = var.instance_type
  subnet_id = aws_subnet.pubsub-1.id
  vpc_security_group_ids = [aws_security_group.webserver-sg.id]
  associate_public_ip_address = true
  tags = var.webservertags
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install apache2 php libapache2-mod-php php-mysql -y

    # Copy PHP files from local directory to web server root
    sudo mkdir -p /var/www/html/myapp
    sudo cp -r /tmp/php_files/* /var/www/html/myapp/
    sudo chown -R www-data:www-data /var/www/html/myapp/*
    sudo systemctl restart apache2
      EOF
}

# create dbserver instance 

resource "aws_instance" "dbserver" {
  ami = var.dbami
  key_name = var.dbserverkeyname
  instance_type = var.instance_type
  subnet_id = aws_subnet.privsub-1.id
  vpc_security_group_ids = [aws_security_group.dbserver-sg.id]
  associate_public_ip_address = false
  tags = var.dbservertags
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install mysql-server -y
    sudo systemctl restart apache2
    EOF
}

