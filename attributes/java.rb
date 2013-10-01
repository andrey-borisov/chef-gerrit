default['java']['version'] = "7u40"
default['java']['package']['name'] = "jdk-#{node['java']['version']}-linux-x64.tar.gz"
default['java']['jdk']['home'] = "/opt/gerrit/jdk1.7.0_40"
default['java']['package']['url'] = "#{node['base_url']}jdk-#{node['java']['version']}-linux-x64.tar.gz"

