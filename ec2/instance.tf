# https://discourse.ubuntu.com/t/search-and-launch-ubuntu-22-04-in-aws-using-cli/27986
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html

data "aws_ami" "instance_ami" {
  # Find AMI: aws ec2 describe-images --owners amazon --region us-east-1
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

}


resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("./devopschallange.pub")
}

# https://aws.amazon.com/pt/ec2/instance-types/
resource "aws_instance" "ec2" {
  ami           = data.aws_ami.instance_ami.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = aws_key_pair.deployer.key_name

  user_data = file("scripts/install.sh")
} 