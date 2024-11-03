#public subnet
resource "aws_security_group" "allow_ssh" {
  name        = format("%s-allow-ssh-bh", var.cluster_name)
  vpc_id      = var.jenkins_vpc_id
  description = "Allow SSH inbound traffic"
  tags = {
    Name       = format("%s-cluster", var.cluster_name)
    created_by = var.created_by
  }

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


# Create an EC2 Instance
resource "aws_instance" "bh_instance" {
  ami                    = var.ami_id
  instance_type          = var.jenkins_ec2_size
  subnet_id              = var.jenkins_subnet_id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  user_data              = <<-EOF
                #!/bin/bash
                #install jenkins
                sudo apt update -y 
                sudo apt install openjdk-17-jre -y 
                curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null 
                echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null sudo 
                apt-get update -y 
                sudo apt-get install jenkins -y
                #install docker
                sudo apt-get update -y
                sudo apt-get install ca-certificates curl -y
                sudo install -m 0755 -d /etc/apt/keyrings
                sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
                sudo chmod a+r /etc/apt/keyrings/docker.asc
                echo \
                "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
                $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
                sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                sudo apt-get update -y
                sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
                sleep 1
                sudo usermod -aG docker ubuntu
                sudo usermod -aG docker jenkins
                sudo systemctl enable docker
                sudo systemctl enable jenkins
                sudo systemctl restart docker
                sudo systemctl restart jenkins
              EOF

  depends_on = [aws_security_group.allow_ssh]
  tags = {
    Name       = format("%s-jenkins", var.cluster_name)
    created_by = var.created_by
  }

}




