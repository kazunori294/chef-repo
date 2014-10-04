#
# Cookbook Name:: kvmhost
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#install kvm kmod-kvm kvm-qemu-img libvirt python-virtinst bridge-utils

package "kvm" do
  action :install
end

package "libvirt" do
  action :install
end

package "python-virtinst" do
  action :install
end

package "bridge-utils" do
  action :install
end

execute "Enable kvm" do
    command <<-EOH
	modprobe kvm
	modprobe kvm_intel
    EOH
end

execute "Linux Bridge" do
    not_if ""
    only_if ""
    command <<-EOH
	cp /etc/sysconfig/network-scripts/ifcfg-eth0 /etc/sysconfig/network-scripts/ifcfg-br0

    EOH
end







