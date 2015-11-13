# comments!

user 'hybris' do
  comment 'hybris service account'
  home "/home/hybris"
  shell '/sbin/nologin'
end

directory "/home/hybris" do
  owner 'hybris'
  group 'hybris'
  mode '0755'
  recursive true
  action :create
end

hybris_service 'default' do
  version '5.7.0.2'
  download_url 'http://19a463ae1a5d4f97483b-b34665fb94ed1b54041aafc4cad3b965.r17.cf3.rackcdn.com/hybris-commerce-suite-5.7.0.2.zip'
  download_checksum 'e6e293f9a1b43faec76daab8b70294099a3df3d7661ff9d29a84cdaaf1340f61'
  action [:create]
end
