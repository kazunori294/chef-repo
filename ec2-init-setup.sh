#!/bin/bash

yum install -y wget >> /tmp/init.log

curl -L get.rvm.io | bash -s stable >> /tmp/init.log
source /etc/profile.d/rvm.sh >> /tmp/init.log
rvm requirements >> /tmp/init.log
rvm install 2.1.2 >> /tmp/init.log
rvm use 2.1.2 --default >> /tmp/init.log
rvm rubygems current >> /tmp/init.log

yum install -y git >> /tmp/init.log

curl -L http://www.opscode.com/chef/install.sh | bash >> /tmp/init.log
gem install knife-solo --no-ri --no-rdoc >> /tmp/init.log

wget -O /root/.ssh/id_rsa  https://s3-ap-northeast-1.amazonaws.com/s3testkazutan/id_rsa >> /tmp/init.log
chmod 600 /root/.ssh/id_rsa

echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
git clone git@github.com:kazunori294/chef-repo.git /etc/chef-repo  >> /tmp/init.log

chef-solo -c /etc/chef-repo/solo.rb -j /etc/chef-repo/nodes/localhost.json >> /tmp/init.log
