default['kibana']['base_dir'] = '/opt/kibana'
default['kibana']['user'] = 'kibana'
default['kibana']['group'] = 'kibana'
default['kibana']['git']['url'] = 'https://github.com/rashidkpc/Kibana.git'
default['kibana']['git']['reference'] = 'v0.2.0'
default['kibana']['interface'] = node['ipaddress']
default['kibana']['port'] = 5601
default['kibana']['elasticsearch']['host'] = '127.0.0.1'
default['kibana']['elasticsearch']['port'] = 9200
default['kibana']['apache']['host'] = node['fqdn']
default['kibana']['apache']['interface'] = node['ipaddress']
default['kibana']['apache']['port'] = 80
default['kibana']['rubyversion'] = '1.9.1'
default['kibana']['use_init_d'] = node['platform_family'] == "debian"
