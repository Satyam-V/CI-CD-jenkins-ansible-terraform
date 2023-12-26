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
  ami           = data.aws_ami.example.id 
  instance_type = "t2.micro" 
  key_name = "jenkinsuse"
  vpc_security_group_ids= ["sg-01b7d18af5d6adf15"]
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
