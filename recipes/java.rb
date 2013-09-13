#java variables
java_pkg_name = node['java']['package']['name']
java_pkg_path = "#{Chef::Config[:file_cache_path]}/#{java_pkg_name}"

#gerrits remote_file
remote_file gerrit_pkg_path do
  source node['gerrit']['package']['url']
  action :create
end

#downloading java
remote_file java_pkg_path do
  source node['java']['package']['url']
  action :create
end
