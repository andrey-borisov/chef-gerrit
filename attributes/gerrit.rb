default['gerrit']['home'] = "/opt/gerrit/"
default['gerrit']['user'] = "gerrit"
default['gerrit']['group'] = "gerrit"
default['gerrit']['port'] = "8081"
default['gerrit']['host'] = "0.0.0.0"
default['gerrit']['version'] = "2.7-rc5"
default['gerrit']['package']['name'] = "gerrit-#{node['gerrit']['version']}.war"
default['gerrit']['package']['url'] = "#{node['base_url']}/gerrit-#{node['gerrit']['version']}.war"

