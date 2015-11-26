
# install mysql and create db
# install mysql instance
mysql2_chef_gem 'default' do
  client_version '5.6'
  provider Chef::Provider::Mysql2ChefGem::Mysql
  action :install
end

mysql_service 'default' do
  port '3306'
  version '5.6'
  initial_root_password 'DummyPassword99'
  action [:create, :start]
end

mysql_client 'default' do
  action :create
end

mysql_database 'hybris' do
  connection(
    :host     => '127.0.0.1',
    :username => 'root',
    :password => 'DummyPassword99'
  )
  collation 'utf8_bin'
  encoding 'utf8'
  action :create
end

mysql_database_user 'hybris' do
  connection(
    :host     => '127.0.0.1',
    :username => 'root',
    :password => 'DummyPassword99'
  )
  host '%'
  password 'DummyPassword88'
  database_name 'hybris'
  action [:create, :grant]
end

#config file with max_allowed_packet = 10M to allow restore
mysql_config 'my-default' do
  instance 'default'
  source 'mysql-default.cnf.erb'
  notifies :restart, 'mysql_service[default]', :immediately
end
