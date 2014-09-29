#
# Cookbook Name:: ruby_on_rails
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

execute "install ruby_on_rails" do
  command <<-EOF
  	yum install -y sqlite-devel
	curl -L get.rvm.io | bash -s stable
	source /etc/profile.d/rvm.sh
	rvm requirements
	rvm install 2.1.2
	rvm use 2.1.2 --default
	rvm rubygems current
	gem install rails --no-ri --no-rdoc
  EOF
end

yum install -y mysql-server
yum install -y mysql-devel

vi /etc/my.cnf
character-set-server = utf8
default-storage-engine=InnoDB

service mysqld start
chkconfig mysqld on
mysqladmin -u root password 'password'


mysql> grant all privileges on *.* to infraweb@localhost identified by 'infraweb';
mysql> grant all privileges on *.* to english@localhost identified by 'english';
mysql> select user,host from mysql.user;
#+----------+------------------+
#| user     | host             |
#+----------+------------------+
#| root     | 127.0.0.1        |
#| root     | ::1              |
#|          | ip-172-31-14-121 |
#| root     | ip-172-31-14-121 |
#|          | localhost        |
#| infraweb | localhost        |
#| root     | localhost        |
#+----------+------------------+

#fail... need to fix


rails new infraweb -d mysql

add gem 'therubyracer'  to  Gemfile
bundle install

rails g controller hosts index

vi config/database.yml
default: &default
  adapter: mysql2
  encoding: utf8
  pool: 5
  username: infraweb
  password: infraweb
  socket: /var/lib/mysql/mysql.sock

rake db:create
mysql> show databases;
+----------------------+
| Database             |
+----------------------+
| information_schema   |
| infraweb_development |
| infraweb_test        |
| mysql                |
| performance_schema   |
| test                 |
+----------------------+

rails server --port=80

rails g model host hostname:string ipaddress:string

cat db/migrate/20140914151945_create_hosts.rb 

rake db:migrate

mysql> use infraweb_development;
mysql> show tables;
+--------------------------------+
| Tables_in_infraweb_development |
+--------------------------------+
| hosts                          |
| schema_migrations              |
+--------------------------------+


vi db/seeds.rb
@host = Host.new
@host.hostname = 'testhost1'
@host.ipaddress = '192.168.1.1'
@host.save

@host = Host.new
@host.hostname = 'testhost2'
@host.ipaddress = '192.168.1.2'
@host.save

rake db:seed

mysql> select * from hosts;
+----+-----------+-------------+---------------------+---------------------+
| id | hostname  | ipaddress   | created_at          | updated_at          |
+----+-----------+-------------+---------------------+---------------------+
|  1 | testhost1 | 192.168.1.1 | 2014-09-14 15:26:30 | 2014-09-14 15:26:30 |
|  2 | testhost2 | 192.168.1.2 | 2014-09-14 15:26:30 | 2014-09-14 15:26:30 |
+----+-----------+-------------+---------------------+---------------------+



#migration
curl -L get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm requirements
rvm install 2.1.2
rvm use 2.1.2 --default
rvm rubygems current
gem install rails --no-ri --no-rdoc

yum -y install git
yum install -y mysql mysql-devel
cd /
git clone https://github.com/kazunori294/rails.git
cd /rails/english
bundle install

#1-1 use localdb
yum install -y mysql-server mysql-devel

vi /etc/my.cnf
character-set-server = utf8
default-storage-engine=InnoDB

service mysqld start
chkconfig mysqld on
mysqladmin -u root password 'password'


mysql> grant all privileges on *.* to infraweb@localhost identified by 'infraweb';
mysql> grant all privileges on *.* to english@localhost identified by 'english';
mysql> select user,host from mysql.user;
mysql> create database english_development;

cd /rails/english
rake db:migrate RAILS_ENV=development


#1-2 use remote db
yum install -y mysql mysql-devel
### if needed
vi config/database.yml


