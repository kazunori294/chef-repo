#
# Cookbook Name:: kvmhost
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#install kvm kmod-kvm kvm-qemu-img libvirt python-virtinst bridge-utils

package "qemu-kvm" do
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
    not_if "lsmod | grep kvm"
    command <<-EOH
	modprobe kvm
    EOH
end

execute "Enable kvm_intel" do
    only_if "cat /proc/cpuinfo | grep vmx"
    not_if "lsmod | grep kvm_intel"
    command <<-EOH
        modprobe kvm_intel
    EOH
end

execute "Linux Bridge" do
    not_if { File.exists?("/etc/sysconfig/network-scripts/ifcfg-br0") }
    command <<-EOH
	cp /etc/sysconfig/network-scripts/ifcfg-eth0 /etc/sysconfig/network-scripts/ifcfg-br0
	echo "BRIDGE=br0" >> /etc/sysconfig/network-scripts/ifcfg-eth0
	sed -i -e "s/eth0/br0/g" /etc/sysconfig/network-scripts/ifcfg-br0
	sed -i -e "s/Ethernet/Bridge/g" /etc/sysconfig/network-scripts/ifcfg-br0
	service network restart
    EOH
end


execute "Setup LVM" do
    not_if "lvdisplay | grep kvm_data"
    command <<-EOH
	lvcreate -n kvm_data -l 100%FREE vg_centos
	mkdir -p /kvm/images
	mkfs.ext4 /dev/vg_centos/kvm_data
	mount /dev/vg_centos/kvm_data /kvm/images
	tail -n 1 /etc/mtab >> /etc/fstab
    EOH
end

service "libvirtd" do
  action [:enable, :start]
end


