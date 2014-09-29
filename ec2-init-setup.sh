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
