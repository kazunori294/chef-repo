#!/bin/bash

yum install -y wget

curl -L get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm requirements
rvm install 2.1.2
rvm use 2.1.2 --default
rvm rubygems current

yum install -y git

curl -L http://www.opscode.com/chef/install.sh | bash
gem install knife-solo --no-ri --no-rdoc

wget -O /root/.ssh/id_rsa  https://s3-ap-northeast-1.amazonaws.com/s3testkazutan/id_rsa
chmod 600 /root/.ssh/id_rsa

echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
git clone git@github.com:kazunori294/chef-repo.git /etc/chef-repo  >> /tmp/init.log

chef-solo -c /etc/chef-repo/solo.rb -j /etc/chef-repo/nodes/localhost.json



#!/usr/bin/ruby 

require 'rubygems'
require 'aws-sdk'

ec2 = AWS::EC2.new(
  :ec2_endpoint => 'ec2.ap-northeast-1.amazonaws.com',
  :access_key_id => '',
  :secret_access_key => ''
)

ec2.instances.each {|ins|
  p ins.id
}



#!/usr/bin/ruby 

require 'rubygems'
require 'aws-sdk'


subnet = 'subnet-eb3108ad'

image_id = 'ami-35072834' ### Amazon Linux
instance_type = 't2.micro'
key_name = 'myaws-key'
security_group_ids = [
  'sg-c97e8fac', ### default
]
#iam_instance_profile = 'default'
ebs_size = 8


ec2 = AWS::EC2.new(
  :ec2_endpoint => 'ec2.ap-northeast-1.amazonaws.com',
  :access_key_id => '',
  :secret_access_key => ''
)

instance = ec2.instances.create(
  image_id:        image_id,
  instance_type:   instance_type,
  key_name:        key_name,
  subnet:          subnet,
  security_group_ids: security_group_ids,
  #iam_instance_profile: iam_instance_profile,
  block_device_mappings: [
    {
      device_name: '/dev/xvda',
      ebs: { volume_size: ebs_size }
    }
  ]
)

while instance.status != :running
  puts "Launching instance #{instance.id}, status: #{instance.status}"
  sleep 5
end



#!/usr/bin/ruby 

require 'rubygems'
require 'aws-sdk'


subnet = 'subnet-eb3108ad'

image_id = 'ami-35072834' ### Amazon Linux
instance_type = 't2.micro'
key_name = 'myaws-key'
security_group_ids = [
  'sg-c97e8fac', ### default
]
#iam_instance_profile = 'default'
ebs_size = 8


ec2 = AWS::EC2.new(
  :ec2_endpoint => 'ec2.ap-northeast-1.amazonaws.com',
  :access_key_id => '',
  :secret_access_key => ''
)

instance = ec2.instances['i-a91e8fb0']
instance.terminate

#while instance.status != :running
#  puts "Launching instance #{instance.id}, status: #{instance.status}"
#  sleep 5
#end



