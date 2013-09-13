default['gerrit']['home'] = "/opt/gerrit1/"
default['gerrit']['user'] = "gerrit"
default['gerrit']['group'] = "gerrit"
default['gerrit']['port'] = "8081"
default['gerrit']['host'] = "0.0.0.0"
default['gerrit']['version'] = "2.7-rc5"
default['gerrit']['package']['name'] = "gerrit-#{node['gerrit']['version']}.war"
default['gerrit']['package']['url'] = "#{node['base_url']}/gerrit-#{node['gerrit']['version']}.war"

=begin
default['java']['version'] = "7u40"
default['java']['pajkage']['name'] = "jdk-#{node['java']['version']}-linux-x64.tar.gz"
default['java']['jdk']['home'] = "/opt/gerrit/jdk-7u40"
default['java']['package']['url'] = "#{node['base_url']}jdk-#{node['java']['version']}-linux-x64.tar.gz"
=end
