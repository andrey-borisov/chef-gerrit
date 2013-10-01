# Gerrit Variables
gerrit_pkg_name = node['gerrit']['package']['name']
gerrit_pkg_path = "#{Chef::Config[:file_cache_path]}/#{gerrit_pkg_name}"
gerrit_user = node['gerrit']['user']
gerrit_group = node['gerrit']['group']
gerrit_home = node['gerrit']['home']


# Java variables
java_pkg_name = node['java']['package']['name']
java_pkg_path = "#{Chef::Config[:file_cache_path]}/#{java_pkg_name}"

# Downloading remote_file
remote_file gerrit_pkg_path do
  source node['gerrit']['package']['url']
  action :create
end

# Downloading java
remote_file java_pkg_path do
  source node['java']['package']['url']
  action :create
end

# Creating gerrit's home directory

execute "Creating gerrit directory" do
  command "mkdir -p #{node['gerrit']['home']}"
  action:run
end

# Unpacking Java to needed us folder
execute "unpack java archive" do
  command "/bin/tar -xvf #{java_pkg_path} -C #{node['gerrit']['home']} && chown -R #{node['gerrit']['user']}:#{node['gerrit']['group']} #{node['gerrit']['home']}"
  cwd "#{node['gerrit']['home']}"
  action :run
end


# Creating gerrit's usergroup
group "gerrit" do
  action :create
end

# Creating gerrit user
user "gerrit" do
  home gerrit_home
  group gerrit_group
  action :create
end

Chef::Log.info("Hey I'm #{node[:tags]}")

# Changing permissions tog gerrits home directory
directory node['gerrit']['home'] do
  owner gerrit_user
  group gerrit_group
  mode "0755"
  action :create
end

# Installing gerrit from *.war
execute "gerrits war installation" do
  command "#{node['java']['jdk']['home']}/bin/java -jar #{gerrit_pkg_path} init -d #{node['gerrit']['home']} && chown -R #{node['gerrit']['user']}:#{node['gerrit']['group']} #{node['gerrit']['home']}" 
  cwd "#{node['gerrit']['home']}"
  action :run
end

# Creating gerrit's config file
template "#{node['gerrit']['home']}etc/gerrit.config" do
  source "gerrit/gerrit.config.erb"
  owner "gerrit"
  group "gerrit"
  mode "0664"
end

# Creating gerrint's enviroment file
template "/etc/default/gerritcodereview" do
  source "gerrit/gerritcodereview.erb"
  owner "gerrit"
  group "gerrit"
  mode "0664"
end


# Creating starting script for daemon startup
template "/etc/init.d/gerrit" do
  source "gerrit/init.d.erb"
  owner "root"
  group "root"
  mode "775"
  notifies :restart, "service[gerrit]", :delayed
end


# Service enable
service "gerrit" do
  action :enable
end
