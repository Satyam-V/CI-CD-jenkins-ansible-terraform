data "aws_ami" "example" {
  executable_users = ["self"]
  most_recent      = true
  name_regex       = "^myami-\\d{3}"
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["myami-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_instance" "test-server" {
  ami           = ami-0b98a32b1c5e0d105
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
