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
