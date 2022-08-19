#######################################################
# FRONTEND LOAD BALANCER SECURITY GROUP
#######################################################

resource "aws_security_group" "JuanSE_SG_LB_Frontend" {
  name        = "JuanSE_SG_LB_Frontend"
  description = "Allow http over ports 8080 and 80 and https over port 443"
  vpc_id      = "vpc-e6246881"

  ingress {
    from_port   = 8080 # Frontend
    protocol    = "TCP"
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0    # Any Outside Port
    protocol    = "-1" # Open all out rule
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { project = "ramp-up-devops", responsible = "juan.sarriase" }
}

#######################################################
# FRONTEND LAUNCH TEMPLATE SECURITY GROUP
#######################################################

resource "aws_security_group" "JuanSE_SG_LT_Frontend" {
  name        = "JuanSE_SG_LT_Frontend"
  description = "Allow http over ports 8080 and 80 and https over port 443"
  vpc_id      = "vpc-e6246881"

  ingress {
    from_port = 8080 # Frontend
    protocol  = "TCP"
    to_port   = 8080
    security_groups = [
      "${aws_security_group.JuanSE_SG_LB_Frontend.id}",
    ]
  }

  ingress {
    from_port   = 22 # SSH
    protocol    = "TCP"
    to_port     = 22
    cidr_blocks = ["190.70.20.93/32"]
  }

  egress {
    from_port   = 0    # Any Outside Port
    protocol    = "-1" # Open all out rule
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { project = "ramp-up-devops", responsible = "juan.sarriase" }
}

#######################################################
# BACKEND LOAD BALANCER SECURITY GROUP
#######################################################

resource "aws_security_group" "JuanSE_SG_LB_Backend" {
  name        = "JuanSE_SG_LB_Backend"
  description = "Allow http over ports 8080 and 80 and https over port 443"
  vpc_id      = "vpc-e6246881"

  ingress {
    from_port   = 8082 # ToDos API
    protocol    = "TCP"
    to_port     = 8082
    security_groups = [
      "${aws_security_group.JuanSE_SG_LT_Frontend.id}",
    ]
  }

  ingress {
    from_port   = 8000 # Auth API
    protocol    = "TCP"
    to_port     = 8000
    security_groups = [
      "${aws_security_group.JuanSE_SG_LT_Frontend.id}",
    ]
  }

  ingress {
    from_port   = 6379 # Log Message
    protocol    = "TCP"
    to_port     = 6379
    security_groups = [
      "${aws_security_group.JuanSE_SG_LT_Frontend.id}",
    ]
  }

  ingress {
    from_port   = 8083 # Users API
    protocol    = "TCP"
    to_port     = 8083
    security_groups = [
      "${aws_security_group.JuanSE_SG_LT_Frontend.id}",
    ]
  }

  egress {
    from_port   = 0    # Any Outside Port
    protocol    = "-1" # Open all out rule
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { project = "ramp-up-devops", responsible = "juan.sarriase" }
}

#######################################################
# BACKEND LAUNCH TEMPLATE SECURITY GROUP
#######################################################

resource "aws_security_group" "JuanSE_SG_LT_Backend" {
  name        = "JuanSE_SG_LT_Backend"
  description = "Allow http over ports 8080 and 80 and https over port 443"
  vpc_id      = "vpc-e6246881"

  ingress {
    from_port = 8082 # ToDos API
    protocol  = "TCP"
    to_port   = 8082
    security_groups = [
      "${aws_security_group.JuanSE_SG_LB_Backend.id}",
    ]
  }

  ingress {
    from_port = 8000 # Auth API
    protocol  = "TCP"
    to_port   = 8000
    security_groups = [
      "${aws_security_group.JuanSE_SG_LB_Backend.id}",
    ]
  }

  ingress {
    from_port = 6379 # Log Message
    protocol  = "TCP"
    to_port   = 6379
    security_groups = [
      "${aws_security_group.JuanSE_SG_LB_Backend.id}",
    ]
  }

  ingress {
    from_port = 8083 # Users API
    protocol  = "TCP"
    to_port   = 8083
    security_groups = [
      "${aws_security_group.JuanSE_SG_LB_Backend.id}",
    ]
  }

  ingress {
    from_port   = 22 # SSH
    protocol    = "TCP"
    to_port     = 22
    cidr_blocks = ["190.70.20.93/32"]
  }

  egress {
    from_port   = 0    # Any Outside Port
    protocol    = "-1" # Open all out rule
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { project = "ramp-up-devops", responsible = "juan.sarriase" }
}