#
# Cookbook Name:: init
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "perl" do
  action :install
end

package "crontabs" do
  action :install
end

execute "Install VMwareTools" do
    not_if "ps aux | grep '/usr/sbin/vmtools[d]'"
    only_if "ifconfig | grep '00:50:56'"
    command <<-EOH
	wget -O /tmp/VMwareTools-9.4.0-1252860.tar.gz  10.1.0.2/tools/VMwareTools-9.4.0-1252860.tar.gz
        tar zxf /tmp/VMwareTools-9.4.0-1252860.tar.gz -C /tmp >> /tmp/chef.log
        perl /tmp/vmware-tools-distrib/vmware-install.pl -d >> /tmp/chef.log
    EOH
end


execute "Setup autoreg script" do
    not_if { File.exists?("/root/script/autoreg.sh") }
    command <<-EOH
	mkdir /root/script
	wget -O /root/script/autoreg.sh  10.1.0.2/scripts/autoreg.sh
	chmod 777 autoreg.sh
	sh /root/script/autoreg.sh
	echo '*/5 * * * *  sh /root/script/autoreg.sh' >>  /var/spool/cron/root
	service crond start
	chkconfig crond on
    EOH
end


execute "Install zabbix agent" do
    not_if "chkconfig | grep 'zabbix-agent'"
    command <<-EOH
	rpm -ivh http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/zabbix-release-2.2-1.el6.noarch.rpm
        yum install -y zabbix-agent-2.2.6-1.el6.i386

	sed -i".org" -e "s/ServerActive=127.0.0.1/ServerActive=zabbix01.kazutan.info/g" /etc/zabbix/zabbix_agentd.conf
	sed -i -e "s/Server=127.0.0.1/Server=zabbix01.kazutan.info/g" /etc/zabbix/zabbix_agentd.conf
	sed -i -e "s/# HostnameItem=system.hostname/HostnameItem=system.hostname/g" /etc/zabbix/zabbix_agentd.conf
	sed -i -e "s/Hostname=Zabbix server/# Hostname=Zabbix server/g" /etc/zabbix/zabbix_agentd.conf

	service zabbix-agent start
	chkconfig zabbix-agent on
    EOH
end
