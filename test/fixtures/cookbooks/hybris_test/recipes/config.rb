
# an config
# install java
node.default['java']['jdk_version'] = '8'
node.default['java']['install_flavor'] = 'oracle'
node.default['java']['oracle']['accept_oracle_download_terms'] = true

include_recipe 'java'
include_recipe 'hybris_test::mysql'

hybris_service 'default' do
  version '5.7.0.2'
  download_url 'http://19a463ae1a5d4f97483b-b34665fb94ed1b54041aafc4cad3b965.r17.cf3.rackcdn.com/hybris-commerce-suite-5.7.0.2.zip'
  download_checksum 'e6e293f9a1b43faec76daab8b70294099a3df3d7661ff9d29a84cdaaf1340f61'
  download_temp_dir '/tmp'
  template 'production'
  ant_initialize true
  ant_update_system true
  rebuild true
  action [:build, :start]
end

node.default['hybris_test']['hybris_config'] = {}
node.default['hybris_test']['hybris_config']['db_conn'] = 'jdbc:mysql://127.0.0.1:3306/hybris?useConfigs=maxPerformance&characterEncoding=utf8'
node.default['hybris_test']['hybris_config']['db_user'] = 'hybris'
node.default['hybris_test']['hybris_config']['db_pass'] = 'DummyPassword88'
node.default['hybris_test']['hybris_config']['db_driver'] = 'com.mysql.jdbc.Driver'

hybris_config 'my custom config' do
  restart true
  source 'local.properties.erb'
  cookbook 'hybris_test'
  variables node['hybris_test']['hybris_config']
  action :create
end
