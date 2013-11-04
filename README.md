Ansible Setup
====
Clone [this repository](http://github.com/deluan/petshop-rails-ansible), which contains the sample ansible project that we will be using.

The ansible project will be launching instances in EC2. In order for this to work, you must set the following environment variables (the ansible ec2 and ec2_group modules have inconsistent variable naming conventions):

    export AWS_ACCESS_KEY=[your AWS access key] && export EC2_ACCESS_KEY=$AWS_ACCESS_KEY
    export AWS_SECRET_KEY=[your AWS secret key] && export EC2_SECRET_KEY=$AWS_SECRET_KEY
    
You will also need the private key to a key pair called "petshop" that has been created in EC2

    ssh-agent
    ssh-add /path/to/petshop.pem

You will also have to create a hosted zone in Route 53 for the domain that these instances will be accessible from and configure the name servers for your domain accordingly. Ansible will handle adding an A record for each instance.

Installation
====
Add the auto-environment gem to your Gemfile:
    
    gem 'auto-environment', git: 'git@github.com:deluan/auto-environments.git'

By default, the output from ansible will be displayed. To run in quiet mode, which only outputs a short status message after execution is complete, include the -q flag. In either case, all output is logged to ./log/auto-environment.log.

Execution
====
Run the gem, passing it the path to the environment YAML file and the ansible project:

    auto-environment environment/staging.yml ../petshop-rails-ansible

Example Environment File
====
staging.yml:

    machines:
      db:
        - common
        - mysql
      www:
        - common
        - ruby19
        - passenger
        - nginx
    network:
      domain: auto-environment.info
