packer-ami/
├── main.pkr.hcl
├── variables.pkr.hcl
└── scripts/
    └── install.sh
---------------------------------------
curl -Lo packer.zip https://releases.hashicorp.com/packer/1.14.3/packer_1.14.3_linux_amd64.zip
unzip packer.zip
mv packer /usr/local/bin/
packer version
-----------------------------------------
packer init .
packer validate .
packer build .
----------------------main.pkr.hcl--------------------
packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.0.0"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  region        = "eu-west-1"
  instance_type = "t3.micro"
  ssh_username  = "ubuntu"
  ami_name      = "demo-ubuntu-{{timestamp}}"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      virtualization-type = "hvm"
      root-device-type    = "ebs"
    }
    owners      = ["099720109477"]
    most_recent = true
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    script = "scripts/install.sh"
  }
}
-----------------scripts/install.sh-------------------
#!/bin/bash
set -e

sudo apt update
sudo apt install -y nginx docker.io
sudo systemctl enable docker

