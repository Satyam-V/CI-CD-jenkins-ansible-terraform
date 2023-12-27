provider "aws" {
  region     = "us-east-1"
}
resource "aws_instance" "test-server" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro" 
  key_name = "jenkinsuse"
  vpc_security_group_ids= ["sg-0137da30f6a773a2e"]
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("./jenkinsuse.pem")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "test-server"
  }
  provisioner "local-exec" {
        command = " echo ${aws_instance.test-server.public_ip} > inventory "
  }
   provisioner "local-exec" {
  command = "ansible-playbook /var/lib/jenkins/workspace/bankapp/my-serverfiles/finance-playbook.yml "
  } 
}
