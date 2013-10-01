#include_recipe 'java'

gerrit_pkg_name = node['gerrit']['package']['name']
gerrit_pkg_path = "#{Chef::Config[:file_cache_path]}/#{gerrit_pkg_name}"
gerrit_user = node['gerrit']['user']
gerrit_group = node['gerrit']['group']
gerrit_home = node['gerrit']['home']


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

#create gerrit directory

execute "Creating gerrit directory" do
  command "mkdir -p #{node['gerrit']['home']}"
  action:run
end

execute "unpack java archive" do
  command "/bin/tar -xvf #{java_pkg_path} -C #{node['gerrit']['home']} && chown -R #{node['gerrit']['user']}:#{node['gerrit']['group']} #{node['gerrit']['home']}"
  cwd "#{node['gerrit']['home']}"
  action :run
end


#creating gerrit's usergroup
group "gerrit" do
  action :create
end

#creating gerrit user
user "gerrit" do
  home gerrit_home
  group gerrit_group
  action :create
end

Chef::Log.info("Hey I'm #{node[:tags]}")

#creating gerrits home directory
directory node['gerrit']['home'] do
  owner gerrit_user
  group gerrit_group
  mode "0755"
  action :create
end

#installing gerrit
execute "gerrits war installation" do
  command "java -jar #{gerrit_pkg_path} init -d #{node['gerrit']['home']} && chown -R #{node['gerrit']['user']}:#{node['gerrit']['group']} #{node['gerrit']['home']}" 
  cwd "#{node['gerrit']['home']}"
  action :run
end

template "#{node['gerrit']['home']}etc/gerrit.config" do
  source "gerrit/gerrit.config.erb"
  owner "gerrit"
  group "gerrit"
  mode "0664"
end

template "/etc/default/gerritcodereview" do
  source "gerrit/gerritcodereview.erb"
  owner "gerrit"
  group "gerrit"
  mode "0664"
end



template "/etc/init.d/gerrit" do
  source "gerrit/init.d.erb"
  owner "root"
  group "root"
  mode "775"
  notifies :restart, "service[gerrit]", :delayed
end



service "gerrit" do
  action :enable
end

