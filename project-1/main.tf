provider "aws" {
    region = "us-east-1"
}

variable "server_port" {
    description = "Port number for web server to use for http reqs"
    type = number
    default = 8080
}

resource "aws_instance" "example" {
    ami                    = "ami-04505e74c0741db8d"
    instance_type          = "t2.micro"
    vpc_security_group_ids = [aws_security_group.instance.id]
    user_data              = <<-EOF
                             #!/bin/bash
                             echo "Fuck you Jeff" > index.html
                             nohup busybox httpd -f -p ${var.server_port} &
                             EOF

    tags = {
        Name = "terraform-example"
    }
}

resource "aws_security_group" "instance" {
    name = "terraform-example-instance"
    ingress {
        from_port   = var.server_port
        to_port     = var.server_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
