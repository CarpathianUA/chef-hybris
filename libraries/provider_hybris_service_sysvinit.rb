require_relative 'provider_hybris_service_base'

class Chef
  class Provider
    class HybrisServiceSysvinit < Chef::Provider::HybrisServiceBase
      provides :hybris_service, os: '!windows' if defined?(provides)

      # TODO: Add proper return codes to startup script.

      action :start do
        service_name = 'hybris_server'
        template "#{new_resource.name} :start /etc/init.d/#{service_name}" do
          path "/etc/init.d/#{service_name}"
          source 'sysvinit/sysvinit_hybris.erb'
          owner 'root'
          group 'root'
          mode '0755'
          variables(
            config: new_resource
          )
          cookbook 'hybris'
          action :create
        end

        service "#{service_name} :enable :start" do
          service_name service_name
          provider Chef::Provider::Service::Init::Redhat if node['platform_family'] == 'redhat'
          provider Chef::Provider::Service::Init::Insserv if node['platform_family'] == 'debian'
          supports restart: true, status: true
          action [:enable, :start]
        end
      end

      action :stop do
        service "#{service_name} :stop" do
          # service_name service_name
          provider Chef::Provider::Service::Init::Redhat if node['platform_family'] == 'redhat'
          provider Chef::Provider::Service::Init::Insserv if node['platform_family'] == 'debian'
          supports restart: true, status: true
          action [:stop]
        end
      end

      action :restart do
        service "#{service_name} :restart" do
          service_name service_name
          provider Chef::Provider::Service::Init::Redhat if node['platform_family'] == 'redhat'
          provider Chef::Provider::Service::Init::Insserv if node['platform_family'] == 'debian'
          supports restart: true
          action :restart
        end
      end

    end
  end
end
