group node['kibana']['group'] do
end

user node['kibana']['user'] do
  comment 'Kibana Server'
  gid node['kibana']['group']
  home node['kibana']['base_dir']
  shell '/bin/bash'
  system true
end

directory node['kibana']['base_dir'] do
  mode '0700'
  owner node['kibana']['user']
  group node['kibana']['group']
  recursive true
end

package 'git'

git node['kibana']['base_dir'] do
  repository node['kibana']['git']['url']
  reference node['kibana']['git']['reference']
  user node['kibana']['user']
  group node['kibana']['group']
  action :checkout
end

apt_package "libcurl4-gnutls-dev"
apt_package "ruby#{node['kibana']['rubyversion']}-full"

link '/usr/bin/ruby' do
  to "/usr/bin/ruby#{node['kibana']['rubyversion']}"
  not_if { ::File.exists?("/usr/bin/ruby")}
end

gem_package 'bundler' do
  gem_binary "/usr/bin/gem#{node['kibana']['rubyversion']}"
end

bash 'kibana bundle install' do
  cwd node['kibana']['base_dir']
  code 'bundle install'
end

service 'kibana' do
  supports :start => true, :restart => true, :stop => true, :status => true
  action :nothing
end

if node['kibana']['use_init_d']

  template '/etc/init.d/kibana' do
    source 'init.erb'
    mode '0755'
    notifies :restart, 'service[kibana]', :delayed
  end

  execute "update-rc.d kibana defaults" do
    command "update-rc.d kibana defaults"
    action :nothing
  end

else

  template '/etc/init/kibana.conf' do
    source 'upstart.conf.erb'
    mode '0600'
    notifies :restart, 'service[kibana]', :delayed
  end

end

template "#{node['kibana']['base_dir']}/KibanaConfig.rb" do
  source 'KibanaConfig.rb.erb'
  user node['kibana']['user']
  group node['kibana']['group']
  mode '0600'
  notifies :restart, 'service[kibana]', :delayed
end

service 'kibana' do
  action [:enable, :start]
end
