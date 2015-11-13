# an config

hybris_config 'hello' do
  instance 'default'
  source 'hello.conf.erb'
  version node['mysql']['version']
  action :create
end
