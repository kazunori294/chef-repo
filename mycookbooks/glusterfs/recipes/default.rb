#
# Cookbook Name:: glusterfs
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

execute "install glusterfs" do
  command <<-EOF 
	cd /etc/yum.repos.d/ && wget http://download.gluster.org/pub/gluster/glusterfs/3.4/3.4.0/EPEL.repo/glusterfs-epel.repo
	yum install -y glusterfs glusterfs-fuse glusterfs-rdma glusterfs-server
	service glusterd start
	service glusterfsd start
	chkconfig glusterd on
	chkconfig glusterfsd on
  EOF
end
