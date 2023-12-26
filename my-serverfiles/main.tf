resource "aws_instance" "test-server" {
  ami           = data.aws_ami.latest_ubuntu.id 
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
