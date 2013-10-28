Usage
=====
* Clone [this repository](http://github.com/deluan/petshop-rails-ansible), which contains the sample ansible project that we will be using
* Run "vagrant up" in the ansible project directory to create the VMs
* In order to ssh to these VMs as the vagrant user, save the [vagrant private key](http://raw.github.com/mitchellh/vagrant/master/keys/vagrant) somewhere and run the following commands:

  `ssh-agent`
  
  `ssh-add /path/to/vagrant_key`
* Run the auto-environments script, passing it the path to the ansible project: 

  `bin/auto-environments ../petshop-rails-ansible`
